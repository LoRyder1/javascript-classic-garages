require 'elasticsearch/model'

class Garage < ActiveRecord::Base
  has_many :comments

  def slug
    title.downcase.gsub(" ", "-")
  end

  def to_param
    "#{id}-#{slug}"
  end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english', index_options: 'offsets'
      indexes :car_type, analyzer: 'english'
    end
  end

  def self.search query
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query, 
            fields: ['name^10', 'car_type']
          }
        },
        highlight: {
          pre_tags: ['<em>'],
          post_tags: ['</em>'],
          fields: {
            name: {},
            car_type: {}
          }
        }
      }
    )
  end

  protected

  # validate
  def ensure_slug_uniqueness
    
    # we also wnat to ensure teh slug is not blank
    if self.slug.blank?
      errors.add(:slug, "can't be blank")
    end

    # if this is a new article, the id is nil
    # otherwise, the slug should point to this article's id
    unless Slug[self.slug].nil? || Slug[self.slug] == self.id.to_s
      errors.add(:slug, "is already taken")
    end
  end


end


  Garage.__elasticsearch__.client.indices.delete index: Garage.index_name rescue nil

  Garage.__elasticsearch__.client.indices.create \
    index: Garage.index_name,
    body: { settings: Garage.settings.to_hash, mappings: Garage.mappings.to_hash }


  Garage.import

# Garage.import
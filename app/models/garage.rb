require 'elasticsearch/model'

class Garage < ActiveRecord::Base
  has_many :comments

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
end


  Garage.__elasticsearch__.client.indices.delete index: Garage.index_name rescue nil

  Garage.__elasticsearch__.client.indices.create \
    index: Garage.index_name,
    body: { settings: Garage.settings.to_hash, mappings: Garage.mappings.to_hash }


  Garage.import

# Garage.import
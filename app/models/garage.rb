require 'elasticsearch/model'

class Garage < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
end

Garage.import

require 'fog/core/model'

module Fog
  module Rackspace
    class Databases
      class Instance < Fog::Model
        identity :id

        attribute :name
        attribute :status
        attribute :hostname
        attribute :created
        attribute :updated
        attribute :links
        attribute :volume
        attribute :flavor
      end
    end
  end
end

require 'fog/core/model'
require 'fog/rackspace/models/cloud_db/callback'

module Fog
  module Rackspace
    class CloudDB

      class Instance < Fog::Model
        identity :id

        attribute :name
        attribute :flavor_id
        attribute :volume
        attribute :databases
        attribute :state, :aliases => 'status'
      end
    end 
  end
end

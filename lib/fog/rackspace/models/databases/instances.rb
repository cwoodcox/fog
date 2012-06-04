require 'fog/core/collection'
require 'fog/rackspace/models/databases/instance'

module Fog
  module Rackspace
    class Databases
      class Instances < Fog::Collection

        model Fog::Rackspace::Databases::Instance

        def all
          data = connection.list_instances_details.body['instances']
          load(data)
        end

        def get(instance_id)
          data = connection.get_instance(instance_id).body['instance']
          new(data)
        rescue Fog::Rackspace::Databases::NotFound
          nil
        end
      end
    end
  end
end

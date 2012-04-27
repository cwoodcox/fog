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

        def databases
          @databases ||= begin
            Fog::Rackspace::Databases::Databases.new({
              :connection => connection,
              :instance => self
            })
          end
        end
      end
    end
  end
end

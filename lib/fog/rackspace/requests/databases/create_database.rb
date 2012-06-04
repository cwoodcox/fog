module Fog
  module Rackspace
    class Databases
      class Real
        def create_database(instance_id, name, options={})
          data = {
            'databases' => [{
              'name' => name
            }]
          }

          if options.has_key? :collate
            data['databases']['collate'] = options[:collate]
          end
          if options.has_key? :character_set
            data['databases']['character_set'] = options[:character_set]
          end

          request(
            :body => MultiJson.encode(data),
            :expects => 202,
            :method => 'POST',
            :path => "instances/#{instance_id}/databases"
          )
        end 
      end
    end
  end
end

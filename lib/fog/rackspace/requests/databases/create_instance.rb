module Fog
  module Rackspace
    class Databases
      class Real
        def create_instance(flavor_ref, size, options={})
          data = {
            'instance' => {
              'flavorRef' => flavor_ref,
              'volume'    => {
                'size'    => size
              }
            }
          }

          if options.has_key? :databases
            data['instance']['databases'] = options[:databases]
          end
          if options.has_key? :name
            data['instance']['name'] = options[:name]
          end

          request(
            :body    => MultiJson.encode(data),
            :expects => 200,
            :method  => 'POST',
            :path    => 'instances.json'
          )
        end
      end
    end
  end
end

module Fog
  module Rackspace
    class CloudDB
      class Real
        def create_db_instance(flavor_ref, size, options={})
          data = {
            'instance' => {
              'databases' => options[:databases],
              'flavorRef' => flavor_ref,
              'name' => options[:name],
              'volume' => {
                'size' => size
              }
            }
          }

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


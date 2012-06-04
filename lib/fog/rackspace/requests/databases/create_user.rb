module Fog
  module Rackspace
    class Databases
      class Real
        def create_user(instance_id, name, password, database_name)
          data = {
            'users' => [{
              'databases' => [{
                'name' => database_name
              }],
              'name'      => name,
              'password'  => password
            }]
          }

          request(
            :body    => MultiJson.encode(data),
            :expects => 202,
            :method  => 'POST',
            :path    => "instances/#{instance_id}/users"
          )
        end
      end
    end
  end
end

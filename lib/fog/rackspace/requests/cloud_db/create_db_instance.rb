module Fog
  module Rackspace
    class CloudDB
      class Real
        def create_db_instance(flavor_ref, size, options={})
	  request({
            'instance' => {
              'databases' => options[:databases],
            'flavorRef' => flavor_ref,
	    'name' => options[:name],
	    'volume' => {
              'size' => size
            }
          })
	end
      end
    end
  end
end


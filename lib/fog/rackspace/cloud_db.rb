require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))

module Fog
  module Rackspace
    class CloudDB < Fog::Service

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent

      model_path 'fog/rackspace/models/cloud_db'

      request_path 'fog/rackspace/requests/cloud_db'

      request :create_db_instance
      request :modify_db_instance
      request :describe_db_instance
      request :describe_db_instances
    end
  end 
end

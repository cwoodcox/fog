require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))

module Fog
  module Rackspace
    class CloudDB < Fog::Service

      DFW_ENDPOINT = 'https://dfw.databases.api.rackspacecloud.com/v1.0/'
      ORD_ENDPOINT = 'https://ord.databases.api.rackspacecloud.com/v1.0/'
      LON_ENDPOINT = 'https://lon.databases.api.rackspacecloud.com/v1.0/'
      
      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url, :persistent
      recognizes :rackspace_auth_token
      recognizes :rackspace_cdb_endpoint

      model_path 'fog/rackspace/models/cloud_db'

      request_path 'fog/rackspace/requests/cloud_db'

      request :create_db_instance
      request :modify_db_instance
      request :describe_db_instance
      request :describe_db_instances
    end
  end 
end

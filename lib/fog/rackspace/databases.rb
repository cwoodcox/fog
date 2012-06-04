require File.expand_path(File.join(File.dirname(__FILE__), '..', 'rackspace'))

module Fog
  module Rackspace
    class Databases < Fog::Service
      DFW_ENDPOINT = 'https://dfw.databases.api.rackspacecloud.com/v1.0/'
      LON_ENDPOINT = 'https://lon.databases.api.rackspacecloud.com/v1.0/'
      ORD_ENDPOINT = 'https://ord.databases.api.rackspacecloud.com/v1.0/'

      requires :rackspace_api_key, :rackspace_username
      recognizes :rackspace_auth_url
      recognizes :rackspace_auth_token

      model_path 'fog/rackspace/models/databases'
      model :flavor
      collection :flavors
      model :instance
      collection :instances
      model :database
      collection :databases
      model :user
      collection :users

      request_path 'fog/rackspace/requests/databases'
      request :check_root_user
      request :create_database
      request :create_instance
      request :create_user
      request :get_flavor
      request :get_instance
      request :list_databases
      request :list_flavors_details
      request :list_instances_details
      request :list_users

      class Mock
        def request(params)
          Fog::Mock.not_implemented
        end
      end

      class Real
        def initialize(options = {})
          @rackspace_api_key = options[:rackspace_api_key]
          @rackspace_username = options[:rackspace_username]
          @rackspace_auth_url = options[:rackspace_auth_url]
          @rackspace_must_reauthenticate = false
          @connection_options = options[:connection_options] || {}

          endpoint = options[:rackspace_databases_endpoint] || DFW_ENDPOINT
          uri = URI.parse(endpoint)

          @host = uri.host
          @persistent = options[:persistent] || false
          @path = uri.path
          @port = uri.port
          @scheme = uri.scheme

          authenticate

          @connection = Fog::Connection.new(uri.to_s, @persistent, @connection_options)
        end

        def request(params)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Content-Type' => 'application/json',
                'X-Auth-Token' => @auth_token
              }.merge!(params[:headers] || {}),
              :host     => @host,
              :path     => "#{@path}/#{params[:path]}"
            }))
          rescue Excon::Errors::NotFound => error
            raise Fog::Rackspace::Errors::NotFound.slurp error
          rescue Excon::Errors::BadRequest => error
            raise Fog::Rackspace::Errors::BadRequest.slurp error
          rescue Excon::Errors::InternalServerError => error
            raise Fog::Rackspace::Errors::InternalServerError.slurp error
          rescue Excon::Errors::HTTPStatusError => error
            raise Fog::Rackspace::Errors::ServiceError.slurp error
          end
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end

        private

        def authenticate
          options = {
            :rackspace_api_key  => @rackspace_api_key,
            :rackspace_username => @rackspace_username,
            :rackspace_auth_url => @rackspace_auth_url
          }
          credentials = Fog::Rackspace.authenticate(options, @connection_options)
          @auth_token = credentials['X-Auth-Token']
          account_id = credentials['X-Server-Management-Url'].match(/.*\/([\d]+)$/)[1]
          @path = "#{@path}/#{account_id}"
        end
      end
    end
  end
end

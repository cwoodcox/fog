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
      model :instance
      collection :instances
      model :flavor
      collection :flavors

      request_path 'fog/rackspace/requests/databases'
      request :list_instances_details
      request :get_instance
      request :list_flavors_details
      request :get_flavor

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
            raise NotFound.slurp error
          rescue Excon::Errors::BadRequest => error
            raise BadRequest.slurp error
          rescue Excon::Errors::InternalServerError => error
            raise InternalServerError.slurp error
          rescue Excon::Errors::HTTPStatusError => error
            raise ServiceError.slurp error
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

require 'fog'
require 'multi_json'
begin
  require 'yajl'
rescue LoadError
  require 'json'
end
# require 'active_support/all'

module Merchii
  module BackgroundReporter
    module Adapters
      class S3

        # Fog::Storage::AWS
        #   requires :aws_access_key_id, :aws_secret_access_key
        #   recognizes :endpoint, :region, :host, :path, :port, :scheme, :persistent

        DEFAULT_OPTIONS = {
          :aws_access_key_id => ENV['AWS_ACCESS_KEY'],
          :aws_secret_access_key => ENV['AWS_ACCESS_SECRET'],
          :region => ENV['AWS_REGION'],
          :endpoint => ENV['AWS_S3_ENDPOINT']
        }

        def initialize(options = {})
          options = DEFAULT_OPTIONS.merge(options)
          key = options.delete(:key)

          # REVIEW: Has issue with regions, get error message if it's not set - jaakko
          # The unspecified location constraint is incompatible for the region specific endpoint this request was sent to.
          s3 = ::Fog::Storage::AWS.new(options)
          s3.region = options[:region]

          @directory = get_directory(s3, key)
        end

        def key?(key)
          !@directory.files.head(key_for(key)).nil?
        end

        def [](key)
          if value = get(key)
            value = deserialize(value.body)
          end
        end

        def []=(key, value)
          store(key, value)
        end

        def fetch(key, value = nil, *)
          self[key] || begin
            value ||= block_given? ? yield(key) : default
            self[key] || value
          end
        end

        def store(key, value, options = {})
          @directory.files.create(:key => key_for(key), :body => serialize(value))
        end

        def delete(key)
          value = get(key)
          if value
            removed_value = deserialize(value.body)
            value.destroy
            removed_value
          end
        end

        def clear
          @directory.files.all.each do |file|
            file.destroy
          end
          self
        end

        private

          def get_directory(connection, name)
            directory_exists?(connection, name) ? find_directory(connection, name) : create_directory(connection, name)
          end

          def directory_exists?(connection, name)
            find_directory(connection, name).present?
          end

          def find_directory(connection, name)
            list_directories(connection).select{ |_directory| _directory.key == name }.first
          end

          def list_directories(connection)
            @_directory_list ||= connection.directories
          end

          def create_directory(connection, name)
            @_directory_list = nil
            connection.directories.create(:key => name, :public => false)
          end

          def key_for(key)
            key.is_a?(String) ? key : serializer.dump(key)
          end

          def serialize(value)
            serializer.dump(value)
          end

          def deserialize(value)
            value && serializer.load(value)
          end

          def get(key)
            @directory.files.get(key_for(key))
          end

          def serializer
            if defined?(::Yajl)
              ::MultiJson.use 'yajl'
            else
              ::MultiJson.use 'json_gem'
            end
            MultiJson
          end

      end
    end
  end
end
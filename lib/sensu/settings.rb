require "sensu/settings/loader"

module Sensu
  module Settings
    DEFAULT_ETCD_NAMESPCE = "/sensu"

    class << self
      # Load Sensu settings.
      #
      # @param [Hash] options
      # @option options [String] :config_file to load.
      # @option options [String] :config_dir to load.
      # @option options [Array] :config_dirs to load.
      # @return [Loader] a loaded instance of Loader.
      def load(options={})
        @loader = Loader.new
        @loader.load_env
        if options[:config_file]
          @loader.load_file(options[:config_file])
        end
        if options[:config_dir]
          @loader.load_directory(options[:config_dir])
        end
        if options[:config_dirs]
          options[:config_dirs].each do |directory|
            @loader.load_directory(directory)
          end
        end
        if options[:etcd_url]
          @loader.load_etcd(
            options[:etcd_url],
            options[:etcd_namespace] || DEFAULT_ETCD_NAMESPCE
          )
        end
        @loader.set_env!
        @loader
      end

      # Retrieve the current loaded settings loader or load one up if
      # there isn't one. Note: We may need to add a mutex for thread
      # safety.
      #
      # @param [Hash] options to pass to load().
      # @return [Loader] instance of a loaded loader.
      def get(options={})
        @loader || load(options)
      end
    end
  end
end

require 'yaml'
require 'fileutils'

module SiteadminCli
  module Config
    class Manager
      CONFIG_PATH = '~/.siteadmin-cli/config.yaml'

      def get_config
        get_config_file_contents(CONFIG_PATH)
      end

      def flush(config)
        write_config CONFIG_PATH, config
      end

      private
      def get_config_file_contents(file_path)
        unless File.file? file_path
          return {}
        end

        YAML::load_file(file_path)
      end

      def write_config(file_path, contents)
        file_path = File.expand_path file_path

        unless File.exists? file_path
          FileUtils.mkpath File.dirname(file_path)
        end

        File.open(file_path, 'a+') {|f| f.write contents.to_yaml}
      end

    end
  end
end
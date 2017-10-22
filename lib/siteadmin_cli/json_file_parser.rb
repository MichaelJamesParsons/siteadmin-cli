require 'siteadmin_cli/exceptions/config_file_not_found_exception'

module SiteadminCli
  class JsonFileParser
    class << self

      def parse(file_path)
        unless File.exist? file_path
          raise SiteadminCli::Exceptions::ConfigFileNotFoundException, 'siteadmin-installer.json does not exist.'
        end

        file = File.read file_path
        JSON.parse file
      end

    end
  end
end
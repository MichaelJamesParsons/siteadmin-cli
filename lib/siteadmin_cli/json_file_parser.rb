require File.dirname(__FILE__) + '/Exceptions/config_file_not_found_exception'

module SiteAdminCli
  class JsonFileParser
    class << self

      def parse(file_name)
        unless File.exist? './' + file_name
          raise ConfigFileNotFoundException, 'siteadmin-installer.json does not exist.'
        end

        file = File.read file_name
        JSON.parse file
      end

    end
  end
end
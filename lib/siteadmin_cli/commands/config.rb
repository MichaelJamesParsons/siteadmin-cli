require 'thor'
require 'yaml'
require 'siteadmin_cli/config/manager'

module SiteadminCli
  module Commands
    class Config < Thor

      option :user, :type => :string
      option :password, :type => :string
      desc 'mysql', '--user <username> | --password <password>'
      def mysql
        config_manager = SiteadminCli::Config::Manager.new
        config = config_manager.get_config

        unless config.key? 'mysql'
          config[:mysql] = {}
        end

        if options[:user]
          config[:mysql][:user] = options[:user]
        end

        if options[:password]
          config[:mysql][:password] = options[:password]
        end

        config_manager.flush config
      end

    end
  end
end

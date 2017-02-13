#!/usr/bin/env ruby
lib = File.expand_path('../../lib', __FILE__)
$:.unshift(lib)

require 'thor'
require_relative 'siteadmin_cli/base'
include SiteadminCli

module Siteadmin

  class Siteadmin < Thor

    # Installs a new siteadmin project.
    #
    # @param [string] project_name
    # @param [string] domain
    desc 'install', 'Install a new Site Administrator project. Parameter 1 is either the name of the
                project or a URL to a git repo.'
    options :p => :string
    def install(project)
      app_builder = SiteadminCli::Installer::ProjectBuilderFactory.make project

      begin
        config = SiteadminCli::JsonFileParser.parse('siteadmin-installer.json')
      rescue SiteadminCli::Exceptions::ConfigFileNotFoundException
        config = {}
      end

      puts 'Installing SA3 directory structure...'
      config = app_builder.build project, config

      app_dir = "#{Dir.pwd}/#{config['name']}"
      executing_dir = File.dirname(__FILE__)

      #todo - handle missing composer.json
      puts 'Installing composer packages...'
      system("bash #{executing_dir}/../bin/composer_update.sh -d \"#{app_dir}/siteadmin\"")

      puts 'Installing mysql...'
      mysql_initializer = SiteadminCli::MySqlService.new
      config = mysql_initializer.initialize_config config
      mysql_initializer.initialize_app_db config

      puts 'Writing siteadmin-installer.json file...'
      # todo - Move to another file
      json_parser = JSON
      file = File.open("#{app_dir}/siteadmin-installer.json", 'w')
      file.write(json_parser.pretty_generate(config))
      file.close

      puts 'Writing SA3 configuration file...'
      system("php #{executing_dir}/php/sa3_config_writer.php -d #{app_dir}")

      puts 'done'
    end

    desc 'ioc COMMAND [<args>...]', 'Manage application ioc files. For these commands to work, you must be inside of a valid Siteadmin project.'
    subcommand 'ioc', Commands::Ioc
  end

end

Siteadmin::Siteadmin.start(ARGV)
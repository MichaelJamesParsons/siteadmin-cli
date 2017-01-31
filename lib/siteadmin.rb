#!/usr/bin/env ruby

require 'thor'
require_relative 'siteadmin_cli/base'
include SiteAdminCli

class Siteadmin < Thor

  # Installs a new siteadmin project.
  #
  # @param [string] project_name
  # @param [string] domain
  desc 'install', 'Install a new Site Administrator project. Parameter 1 is either the name of the
                project or a URL to a git repo.'
  options :p => :string
  def install(project)
    app_builder = SiteAdminCli::ProjectBuilderFactory.make project

    begin
      config = SiteAdminCli::JsonFileParser.parse('siteadmin-installer.json')
    rescue SiteAdminCli::Exceptions::ConfigFileNotFoundException
      config = {}
    end

    app_dir = "#{Dir.pwd}/#{config['name']}"
    executing_dir = File.dirname(__FILE__)

    puts 'Installing mysql...'
    mysql_initializer = SiteAdminCli::MySqlService.new
    mysql_initializer.initialize_config config
    mysql_initializer.initialize_app_db config

    put 'Installing SA3 directory structure...'
    config = app_builder.build project, config

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

end

Siteadmin.start(ARGV)
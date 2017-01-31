#!/usr/bin/env ruby

require 'thor'
require_relative 'siteadmin_cli/base'
include SiteAdminCli

# @todo - Implement:
#
# - clear IOC
# - update doctrine
# - rollback composer
#
class Siteadmin < Thor

  # Installs a new siteadmin project.
  #
  # @todo create siteadmin-installer.json file
  # @todo create database user
  # @todo execute sa3_config_writer.php
  #
  # @param [string] project_name
  # @param [string] domain
  desc 'init', 'Install a new Site Administrator project. Parameter 1 is either the name of the
                project or a URL to a git repo.'
  options :p => :string
  def init(project)
    app_builder = SiteAdminCli::ProjectBuilderFactory.make project

    begin
      config = SiteAdminCli::JsonFileParser.parse('siteadmin-installer.json')
    rescue SiteAdminCli::Exceptions::ConfigFileNotFoundException
      config = {}
    end

    app_dir = "#{Dir.pwd}/#{config['name']}"
    executing_dir = File.dirname(__FILE__)

    puts 'installing mysql user'
    config['name'] = project_name

    unless config['domain']
      config['domain'] = project_name + '.app'
    end

    mysql_initializer = SiteAdminCli::MySqlService.new
    mysql_initializer.initialize_config config
    mysql_initializer.initialize_app_db config
    puts 'mysql setup complete'


    app_builder.build config

    # Move to new project builder
    puts "installing app...#{project_name}"
    system("bash #{executing_dir}/../bin/siteadmin_install.sh -d \"#{app_dir}\"")
    puts 'Installation complete'

    # Move
    puts 'writing config file'
    json_parser = JSON
    file = File.open("#{app_dir}/siteadmin-installer.json", 'w')
    file.write(json_parser.pretty_generate(config))
    file.close
    puts 'config complete'

    # All?
    puts 'executing php scripts...'
    system("php #{executing_dir}/php/sa3_config_writer.php -d #{app_dir}")
    puts 'done'
  end

  # Sets up an existing siteadmin project.
  #
  # @param [string] project_name
  # @param [string] domain
  # @param [string] git_repo
  desc 'setup', 'Install an existing Site Administrator project from a Git Repo.'
  def setup(git_repo: nil)

  end
end

Siteadmin.start(ARGV)
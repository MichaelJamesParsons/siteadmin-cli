#!/usr/bin/env ruby
require 'thor'
require './siteadmin_cli/base'
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
  desc 'init', 'Install a new Site Administrator project.'
  options :p => :string
  def init(project_name)
    unless project_name =~ /^[a-zA-Z_]*$/
      puts "Invalid project name \"#{project_name}\". Project name may only contain alphabetic characters and underscores."
    end

    begin
      config = SiteAdminCli::JsonFileParser.parse('siteadmin-installer.json')
    rescue SiteAdminCli::Exceptions::ConfigFileNotFoundException
      config = {}
    end

    puts 'installing mysql user'
    config['name'] = project_name
    mysql_initializer = SiteAdminCli::MySqlService.new
    mysql_initializer.initialize_config config
    mysql_initializer.initialize_app_db config

    puts 'user create complete'

    json_parser = JSON
    file = File.open('./siteadmin-installer.json', 'w')
    file.write(json_parser.generate(config))

    puts "installing app...#{project_name}"
    #system('bash ./../bin/siteadmin_install.sh')
    puts 'Installation complete'
  end

  # Sets up an existing siteadmin project.
  #
  # @param [string] project_name
  # @param [string] domain
  # @param [string] git_repo
  desc 'setup', 'Install an existing Site Administrator project from a Git Repo.'
  def setup(project_name, domain, git_repo: nil)

  end
end

Siteadmin.start(ARGV)
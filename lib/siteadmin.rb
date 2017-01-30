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

    puts "installing app...#{project_name}"
    system("bash #{executing_dir}/../bin/siteadmin_install.sh -d \"#{app_dir}\"")
    puts 'Installation complete'

    puts 'writing config file'
    json_parser = JSON
    file = File.open("#{app_dir}/siteadmin-installer.json", 'w')
    file.write(json_parser.pretty_generate(config))
    puts 'config complete'

    puts 'executing php scripts...'
    #system('php ./php/sa3_config_writer.php')
    puts 'done'
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
#!/usr/bin/env ruby
require 'thor'
require File.dirname(__FILE__) + '/siteadmin_cli/json_file_parser'
require File.dirname(__FILE__) + './siteadmin_cli/my_sql_initializer'
require File.dirname(__FILE__) + './siteadmin_cli/Exceptions/config_file_not_found_exception'

class Siteadmin < Thor
  desc 'init', 'Install a siteadmin from configuration file.'

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
      config = SiteadminCli::JsonFileParser.parse('siteadmin-installer.json')
    rescue SiteadminCli::Exceptions::ConfigFileNotFoundException
      config = {}
    end

    mysql_initializer = SiteadminCli::MySqlInitializer.new

    config2 = mysql_initializer.initialize_config config

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
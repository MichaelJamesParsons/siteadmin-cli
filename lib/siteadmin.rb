#!/usr/bin/env ruby
require 'thor'

class Siteadmin < Thor
  desc 'init', 'Install a siteadmin from configuration file.'
  def init

  end

  # Installs a new siteadmin project.
  #
  # @todo create siteadmin-installer.json file
  # @todo create database user
  # @todo send POST request to setupController
  #
  # @param [string] project_name
  # @param [string] domain
  desc 'install', 'Install a new Site Administrator project.'
  options :p => :string
  def install(project_name)
    unless project_name =~ /^[a-zA-Z_]*$/
      puts "Invalid project name \"#{project_name}\". Project name may only contain alphabetic characters and underscores."
    end

    puts "installing app...#{project_name}"
    system('bash ./../bin/siteadmin_install.sh')
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
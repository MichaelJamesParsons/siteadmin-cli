require 'thor'

class Siteadmin < Thor
  # Installs a new siteadmin project.
  #
  # @param [string] project_name
  # @param [string] domain
  def install(project_name, domain)

  end

  # Sets up an existing siteadmin project.
  #
  # @param [string] project_name
  # @param [string] domain
  # @param [string] git_repo
  def setup(project_name, domain, git_repo: nil)

  end
end

Siteadmin.start(ARGV)
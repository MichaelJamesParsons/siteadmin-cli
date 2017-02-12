module SiteadminCli
  require 'json'
  require 'siteadmin_cli/json_file_parser'
  require 'siteadmin_cli/my_sql_service'
  require 'siteadmin_cli/composer_service'
  require 'siteadmin_cli/git_service'
  require 'siteadmin_cli/new_project_builder'
  require 'siteadmin_cli/repository_project_builder'
  require 'siteadmin_cli/project_builder_factory'
  require 'siteadmin_cli/Exceptions/config_file_not_found_exception'
  require 'siteadmin_cli/Commands/ioc'

  include SiteadminCli::Exceptions
end
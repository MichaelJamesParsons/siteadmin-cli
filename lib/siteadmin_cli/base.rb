module SiteAdminCli
  require './siteadmin_cli/json_file_parser'
  require './siteadmin_cli/my_sql_initializer'
  require './siteadmin_cli/Exceptions/config_file_not_found_exception'

  include SiteAdminCli::Exceptions
end
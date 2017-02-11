module SiteAdminCli
  class RepositoryProjectBuilder
    def build(project, config)
      config['name'] = SiteAdminCli::GitService::parse_project_name_from_url project
      config['domain'] = project

      SiteAdminCli::GitService::clone project, config['name']

      config
    end
  end
end
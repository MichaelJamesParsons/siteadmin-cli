module SiteadminCli
  class RepositoryProjectBuilder
    def build(project, config)
      config['name'] = SiteadminCli::GitService::parse_project_name_from_url project
      config['domain'] = project

      SiteadminCli::GitService::clone project, config['name']

      config
    end
  end
end
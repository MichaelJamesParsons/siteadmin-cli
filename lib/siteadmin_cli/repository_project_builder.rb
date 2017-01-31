module SiteAdminCli
  class RepositoryProjectBuilder
    class << self
      def build(project, config)
        config['name'] = SiteAdminCli::GitService::parse_project_name_from_url project
        SiteAdminCli::GitService::clone project

        config
      end
    end
  end
end
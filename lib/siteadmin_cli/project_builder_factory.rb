module SiteAdminCli
  class ProjectBuilderFactory
    class << self

      def make(project)
        if project =~ URI.regexp
          return NewProjectBuilder
        elsif project =~ /^[a-zA-Z_]*$/
          return RepositoryProjectBuilder
        end

        raise Exception, 'Invalid project. Expected project name [a-zA-Z_] or url to git repository.'
      end

    end
  end
end
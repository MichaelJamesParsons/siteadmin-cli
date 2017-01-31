module SiteAdminCli
  class GitService
    class << self
      def clone(repo, dest = '.')
        system("#{File.dirname(__FILE__)}/../../bin/git_push.sh -r #{repo} -d #{dest}")
      end

      def parse_project_name_from_url(url)
        last_slash = url.rindex '/\//'

        if url.include? '@'
          return url[last_slash + 1]
        end

        url[last_slash, -4]
      end
    end
  end
end
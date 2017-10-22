module SiteadminCli
  class GitService
    class << self
      def clone(repo, dest = '.')
        system("bash #{File.dirname(__FILE__)}/../../scripts/git_clone.sh -r #{repo} -d #{dest}")
      end

      def parse_project_name_from_url(url)
        last_slash = url.to_s.rindex(/\//)

        if url.include? '@'
          return url[last_slash + 1, url.length]
        end

        url[last_slash+1..-5]
      end
    end
  end
end
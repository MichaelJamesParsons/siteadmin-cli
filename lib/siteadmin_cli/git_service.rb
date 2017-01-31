
module SiteAdminCli
  class GitService
    class << self
      def clone(repo)
        system("#{File.dirname(__FILE__)}/../../bin/git_push.sh -r #{repo}")
      end
    end
  end
end
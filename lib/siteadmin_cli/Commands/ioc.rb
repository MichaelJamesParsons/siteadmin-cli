require 'thor'

module SiteadminCli
  module Commands
    class Ioc < Thor

      desc 'reload', 'Reload IOC files'
      def reload
        puts 'Reloading IOC files...'
        sa_dir = get_project_directory Dir.pwd
      end

      private
      def get_project_directory(dir)
        sibling_dirs = Dir.glob('**/')

        unless sibling_dirs.include? 'siteadmin'
          return get_project_directory File.expand_path('../', dir)
        end

        dir
      end
    end
  end
end
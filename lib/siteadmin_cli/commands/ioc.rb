require 'thor'
require 'siteadmin_cli/exceptions/file_not_found_exception'
require 'siteadmin_cli/utils/project_traversal_utils'

module SiteadminCli
  module Commands
    class Ioc < Thor

      # Deletes a IoC files from a siteadmin project.
      desc 'reload', 'Reload IOC files'
      def reload
        begin
          project_dir = SiteadminCli::Utils::ProjectTraversalUtils.get_project_directory Dir.pwd
          purge_ioc_from_project_dir project_dir
        rescue SiteadminCli::Exceptions::FileNotFoundException => ex
          puts ex.message
        end
      end

      private

      # Deletes IoC files from a project's tmp directory.
      #
      # @param [Object] dir - The project root directory path.
      def purge_ioc_from_project_dir(dir)
        ioc_file_path = "#{dir}/tmp/ioc.json"

        if File.exist? ioc_file_path
          File.delete ioc_file_path
        end

        raise SiteadminCli::Exceptions::FileNotFoundException,
              "IOC files appear to have already been deleted from \"#{File.dirname(ioc_file_path)}\""
      end
    end
  end
end
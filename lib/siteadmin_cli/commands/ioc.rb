require 'thor'
require 'siteadmin_cli/exceptions/file_not_found_exception'

module SiteadminCli
  module Commands
    class Ioc < Thor

      # Deletes a IoC files from a siteadmin project.
      desc 'reload', 'Reload IOC files'
      def reload
        begin
          project_dir = get_project_directory Dir.pwd
          purge_ioc_from_project_dir project_dir
        rescue SiteadminCli::Exceptions::FileNotFoundException => ex
          puts ex.message
        end
      end

      private
      # Returns the root directory of a Siteadmin project.
      #
      # The directory hierarchy is recursively searched from the current directory
      # until either the project root is found or the root path is reached.
      #
      # A project directory is identified by the presence of a "siteadmin-installer.json" file.
      #
      # @param [string] dir - The directory from which to begin searching for the project root directory.
      # @return [string] The project root directory.
      def get_project_directory(dir)
        sibling_dirs = Dir["#{dir}/*"].map { |a| File.basename(a) }

        if sibling_dirs.include? 'siteadmin-installer.json'
          return dir
        elsif dir == '/'
          raise SiteadminCli::Exceptions::FileNotFoundException,
                'You must be inside of a Siteadmin project directory to perform this action. ' +
                'Does a siteadmin-installer.json file exist in your project? ' +
                "Execute the following command while in the root of your project to generate one for you:\n\n\n" +
                "\tsiteadmin init\n\n\n"
        end

        get_project_directory File.absolute_path("#{dir}/../")
      end

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
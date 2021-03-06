module SiteadminCli::Utils
  class ProjectTraversalUtils
    class << self

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
          return File.absolute_path dir
        elsif dir == '/'
          raise SiteadminCli::Exceptions::FileNotFoundException,
                'You must be inside of a Siteadmin project directory to perform this action. ' +
                    'Does a siteadmin-installer.json file exist in your project? ' +
                    "Execute the following command while in the root of your project to generate one for you:\n\n\n" +
                    "\tsiteadmin init\n\n\n"
        end

        get_project_directory File.absolute_path("#{dir}/../")
      end

    end
  end
end
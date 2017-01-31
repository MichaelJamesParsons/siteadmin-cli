module SiteAdminCli
  class NewProjectBuilder
    def build(project, config)
      app_dir = "#{Dir.pwd}/#{project}"
      executing_dir = File.dirname(__FILE__)
      system("bash #{executing_dir}/../bin/siteadmin_install.sh -d \"#{app_dir}\"")

      config
    end
  end
end
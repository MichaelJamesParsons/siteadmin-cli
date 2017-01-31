module SiteAdminCli
  class ComposerService
    class << self

      def update(dir = nil?)
        if dir.nil?
          dir = Dir.pwd
        end

        System("#{File.dirname(__FILE__)}/../../composer_update.sh -d #{dir}")
      end

    end
  end
end
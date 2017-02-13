require 'thor'
require 'siteadmin_cli/commands/composer_listener'
require 'siteadmin_cli/commands/composer_history'

module SiteadminCli
  module Commands
    class Composer < Thor

      desc 'update', 'Updates composer dependencies'
      def update
        puts 'Updating composer.json'
      end

      desc 'refresh-autoload', 'Regenerates composer autoload files'
      option :o
      def refresh_autoload
        puts 'Reloading composer autoload'
      end

      subcommand('listen', ComposerListen)
      subcommand('history', ComposerHistory)

    end
  end
end
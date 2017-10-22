require 'thor'
require 'siteadmin_cli/commands/composer_listen'
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

      desc 'listen', 'Manage composer.json change listener'
      subcommand('listen', ComposerListen)

      desc 'history', 'Manage composer.json history'
      subcommand('history', ComposerHistory)

    end
  end
end
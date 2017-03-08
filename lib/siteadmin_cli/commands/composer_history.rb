require 'thor'
require 'siteadmin_cli/composer/composer'

module SiteadminCli
  module Commands
    class ComposerHistory < Thor

      desc 'top', 'Restores the most recent composer file.'
      def top
        puts 'Restoring most recent version'
      end

      desc 'rewind', 'Restores the next recent composer file.'
      def rewind
        puts 'Restoring composer to previous version'
        listener = SiteadminCli::Composer::ComposerListener.new
        listener.rewind Dir.pwd
      end

      desc 'forward', 'Restores previous version composer file.'
      def forward
        puts 'Restoring composer to next recent version'
      end

      desc 'restore', 'Restores a specific entry from the history.'
      def restore(entry_id)
        puts 'Restoring a specific composer version'
      end

      desc 'preview', 'Displays the contents of an entry in the history.'
      def preview(entry_id)
        puts 'Viewing content of composer history item'
      end

      desc 'list', 'Lists all of the entries in the history'
      def list
        puts 'Listing all history'
      end

    end
  end
end
require 'thor'

module SiteadminCli
  module Commands
    class ComposerListen < Thor

      desc 'start', 'Enables listener to track changes to composer.json.'
      def start
        puts 'Listening to composer file'
      end

      desc 'stop', 'Disables composer.json change listener.'
      def stop
        puts 'Stopped listening to composer file'
      end

      desc 'status', 'Determine if listener is running'
      def status
        puts 'The listener <is|is not> listening'
      end

    end
  end
end
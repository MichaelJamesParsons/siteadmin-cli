require 'digest'
require 'time'

module SiteAdminCli
  class MySqlInitializer

    # @param [{}] config
    def initialize_config(config)

      # Set database host
      unless config.key?('db_host')
        config['db_host'] = 'localhost'
      end

      # Set database name
      unless config.key?('db_name')
        config['db_name'] = config['name']
      end

      # Set database user
      unless config.key?('db_user')
        config['db_user'] = config['name']
      end

      # Set database password
      unless config.key?('db_pass')
        hash = Digest::MD5.new
        hash << Time.now.to_s
        config['db_pass'] = hash.to_s
      end

      config
    end

  end
end
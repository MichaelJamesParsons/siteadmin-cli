require 'digest'
require 'time'

module SiteAdminCli
  class MySqlService

    # @param [{}] config
    def initialize_config(config)

      unless config.key? 'mysql'
        config['mysql'] = {}
      end

      # Set database host
      unless config['mysql'].key? 'host'
        config['mysql']['host'] = 'localhost'
      end

      # Set database name
      unless config['mysql'].key? 'name'
        config['mysql']['name'] = config['name']
      end

      # Set database user
      unless config['mysql'].key? 'user'
        config['mysql']['user'] = config['name']
      end

      # Set database password
      unless config['mysql'].key? 'pass'
        hash = Digest::MD5.new
        hash << Time.now.to_s
        config['mysql']['pass'] = hash.to_s
      end

      config
    end

    def initialize_app_db(config)

      if config['mysql']['root']['user']
        user = config['mysql']['root']['user']
      else
        user = 'root'
      end

      if config['mysql']['root']['pass']
        pass = config['mysql']['root']['pass']
      else
        pass = 'root'
      end

      puts 'start'
      conn_str = "bash ./../bin/mysql_create_database.sh -u \"#{user}\" -p \"#{pass}\" -n \"#{config['mysql']['app']['name']}\""
      puts conn_str
      system(conn_str)
      puts 'stop'
    end

    def create_database(name)

    end

    def create_user

    end

    def assign_user_to_database(db_name, user)

    end

    def attempt_to_connect(config)

    end


  end
end
require 'digest'
require 'time'

module SiteadminCli
  class MySqlService

    # @param [{}] config
    def initialize_config(config)

      if config.nil?
        config = {}
      end

      unless config.key? 'mysql'
        config['mysql'] = { app: {} }
      end

      unless config['mysql'].key? 'app'
        config['mysql']['app'] = {}
      end

      # Set database host
      unless config['mysql']['app'].key? 'host'
        config['mysql']['app']['host'] = 'localhost'
      end

      # Set database name
      unless config['mysql']['app'].key? 'name'
        config['mysql']['app']['name'] = config['name'].gsub(/[-]/, '_')
      end

      # Set database user
      unless config['mysql']['app'].key? 'user'
        config['mysql']['app']['user'] = config['name'].gsub(/[-]/, '_')
      end

      # Set database password
      unless config['mysql'].key? 'pass'
        hash = Digest::MD5.new
        hash << Time.now.to_s
        config['mysql']['app']['pass'] = hash.to_s
      end

      config
    end

    def initialize_app_db(config)

      unless config['mysql'].key? 'root'
        config['mysql']['root'] = {}
      end

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

      create_database(user, pass, config['mysql']['app']['name'])
      create_user(user, pass, config['mysql']['app']['user'], config['mysql']['app']['pass'])
      assign_user_to_database(user, pass, config['mysql']['app']['user'], config['mysql']['app']['name'], config['mysql']['app']['host'])
    end

    def create_database(user, pass, db_name)
      system("bash #{File.dirname(__FILE__)}/../../bin/mysql_create_database.sh -u \"#{user}\" -p \"#{pass}\" -n \"#{db_name}\"")
    end

    def create_user(root_user, root_pass, new_user, new_pass)
      system("bash #{File.dirname(__FILE__)}/../../bin/mysql_create_user.sh -u \"#{root_user}\" -p \"#{root_pass}\" -n \"#{new_user}\" -i \"#{new_pass}\"")
    end

    def assign_user_to_database(root_user, root_pass, user, db_name, host)
      system("bash #{File.dirname(__FILE__)}/../../bin/mysql_set_user_privileges.sh -u \"#{root_user}\" -p \"#{root_pass}\" -n \"#{user}\" -d \"#{db_name}\" -h \"#{host}\"")
    end

  end
end
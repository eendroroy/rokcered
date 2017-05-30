module DockerizeRails
  class DRConfig
    ATTRIBUTES = %i[
      application_name ruby_version application_env application_port postgres_version mysql_version
      database_root_pass database_user_name database_user_pass databases
    ].freeze

    @application_name     = 'dockerize_rails'

    @ruby_version         = 'latest'
    @application_env      = 'development'
    @application_port     = '5000'

    @postgres_version     = 'alpine'
    @mysql_version        = 'latest'

    @database_root_pass   = 'root'
    @database_user_name   = 'user'
    @database_user_pass   = 'pass'

    @databases            = {}

    def self.load_dockerize_rails_config
      dockerize_rails_config_file = File.join(PATHS.current, Constants::DOCKERIZE_RAILS_CONFIG_FILE_NAME)
      if File.exist? dockerize_rails_config_file
        dockerize_rails_config = YAML.load_file(dockerize_rails_config_file)
        ATTRIBUTES.each do |attr|
          attr_conf = dockerize_rails_config[attr.to_s]
          send("#{attr}=", attr_conf) unless attr_conf.to_s.empty?
        end
      else
        puts "\nDockerizeRails config file not generated...".yellow
        puts "Run 'bundle exec dock configure' to generate configuration file.\n".yellow
      end
    end

    def self.to_yaml_str
      "---
# Set application name
#
# Default is #{application_name}
application_name: #{application_name}

# Set ruby version
# Visit: https://hub.docker.com/_/ruby/ for list of available versions
#
# Default is #{ruby_version}
ruby_version: #{ruby_version}

# Set docker container's rails environment to production, staging, or development
# Make sure application is properly configured to run in 'application_env' (#{application_env})
#
# Default is #{application_env}
application_env: #{application_env}

# Set docker container's rails port to access from local machine
# Make sure it doesn't conflict with any of the ports active in host machine
#
# Default #{application_port}
application_port: #{application_port}

# Set root password for docker database container
# it doesn't make any changes in your computer's database
# It will be used only for MySQL database
#
# Default #{database_root_pass}
database_root_pass: #{database_root_pass}

# Set postgres database version if application uses postgres
# Visit: https://hub.docker.com/_/postgres/ for list of available versions
#
# Default is #{postgres_version}
postgres_version: #{postgres_version}

# Set mysql database version if application uses mysql
# Visit: https://hub.docker.com/_/mysql/ for list of available versions
#
# Default is #{mysql_version}
mysql_version: #{mysql_version}

# Set database properties

# Default database username for container's internal use
# It has no impact on host machine's database
# Default #{database_user_name}
database_user_name: #{database_user_name}

# Default database password for container's internal use
# It has no impact on host machine's database
# Default #{database_user_pass}
database_user_pass: #{database_user_pass}
"
    end

    def self.to_hash
      Hash[ATTRIBUTES.map do |accessor|
        [accessor, send(accessor.to_s)]
      end]
    end

    class << self
      attr_accessor(*ATTRIBUTES)
    end
  end
end

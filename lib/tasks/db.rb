# from http://gist.github.com/279918
namespace :db do
 
  desc 'Seed database from db/seed.sql file instead of the traditional db/seed.rb'
  namespace :seed do
    config = Rails::Configuration.new.database_configuration[RAILS_ENV]
    
    seed_sql = File.expand_path(File.dirname(__FILE__) + '/../../db/seed.sql')
 
    if !File.exists?(seed_sql)
      puts "Missing RAILS_ROOT/db/seed.sql"
    else
      case config['adapter']
      when 'mysql'
        database = config['database']
        username = config['username']
        password = config['password']
        `mysql #{database} -u#{username} -p#{password} < #{seed_sql}`
      when 'sqlite3'
        database = config['database']
        `sqlite3 #{database} < #{seed_sql}`
      else
        puts "Wrong adapter. Only MySQL and Sqlite3 are supported."
      end
    end
    
  end
end
#
# override ActiveRecord settings for testing
#
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

migrate_path = File.expand_path('../rails-app/db/migrate', __dir__)

if Rails.version.start_with?('6') || Rails.version.start_with?('7')
  ActiveRecord::MigrationContext.new(migrate_path, ActiveRecord::SchemaMigration).migrate
elsif Rails.version.start_with? '5.2'
  ActiveRecord::MigrationContext.new(migrate_path).migrate
else
  ActiveRecord::Migrator.migrate(migrate_path)
end

#
# override ActiveRecord settings for testing
#
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

if ActiveRecord::Migrator.respond_to?(:migrate)
  ActiveRecord::Migrator.migrate(File.expand_path('../rails-app/db/migrate', __dir__))
else
  ActiveRecord::MigrationContext.new(File.expand_path('../rails-app/db/migrate', __dir__)).migrate
end
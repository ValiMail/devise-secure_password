#
# override ActiveRecord settings for testing
#
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)
path = File.expand_path('../rails-app/db/migrate', __dir__)

if ActiveRecord::Migrator.respond_to?(:migrate)
  ActiveRecord::Migrator.migrate(path)
else
  args = [path]
  args << ActiveRecord::Base.connection.schema_migration if Gem.loaded_specs['rails'].version.to_s.match(/^6\.0/)
  ActiveRecord::MigrationContext.new(*args).migrate
end

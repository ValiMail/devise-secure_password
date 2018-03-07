#
# override ActiveRecord settings for testing
#
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

ActiveRecord::Migrator.migrate(File.expand_path('../rails-app/db/migrate', __dir__))

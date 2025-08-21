### Upgrading to a New Rails Version

This gem uses so-called "dummy" apps in the specs to verify compatibility with a major/minor version of Rails.  Adding a new major/minor version of Rails requires us to add a new "dummy" app in the spec folder, and a corresponding Gemfile in the gemfiles directory.  While manual, this process is relatively straightforward:

1. Create a new Rails app in the directory `spec/rails_<major>_<minor>` by using the Rails generator for that version, ensuring you skip Git setup.  (e.g. `cd spec; rails _7.2.2.2_ new rails-app-7_0 --skip-git`)

2. Move the Gemfile from the newly created app to the `gemfiles` directory and rename it with the major/minor version (e.g. `mv spec/rails_7_0/Gemfile gemfiles/rails_7_0.gemfile`)

3. Update the Gemfile to include the Rails target and gemspec immediately beneath the source declarations, like this:

```ruby
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ENV['RAILS_TARGET'] ||= '7.0'

gemspec path: '../'
```

4. Add `gem 'shoulda-matchers'` under the test group in the new Gemfile

5. Ensure you can bundle by running `bundle` with the `BUNDLE_GEMFILE` variable set to the new Gemfile (i.e. `BUNDLE_GEMFILE=gemfiles/rails_7_0.gemfile bundle`).  This should run successfully - fix as needed.

6. Copy the file `config/initializers/devise.rb` from an existing "dummy" app to the same location in the new app.

7. Copy the file `config/routes.rb` from an existing "dummy" app to the same location in the new app.

8. Copy the contents of the `db/migrate` directory from an existing "dummy" app to the same location in the new app.  Copy the `db/schema.rb` and `db/test.sqlite3` as well

9. Copy the `app/controllers/static_pages_controller.rb` from an existing "dummy" app to the same location in the new app.

10. Copy the `app/models/isolated` directory and the `app/models/user.rb` file from an existing "dummy" app to the same location in the new app.

11. Copy the `app/views/static_pages` directory from an existing "dummy" app to the same location in the new app.

12. Update the `app/views/layouts/application.html.erb` in the new app to have the same `<body>` content and `<title>` as the same file in an existing "dummy" app.

13. At this point you should be able to run specs.  (i.e. `BUNDLE_GEMFILE=gemfiles/rails_6_1.gemfile bundle exec rake`).  Run specs and fix version specific issues, taking care to maintain backwards compatibility with supported versions.

14. You should also run Rubocop (i.e. `BUNDLE_GEMFILE=gemfiles/rails_7_0.gemfile bundle exec rubocop`) and fix whatever issues are reported (again, maintaining backwards compatibility)

15. In the `.circleci/config.yml` file update the `current_rails_gemfile` and `previous_rails_gemfile` to reference the new version and the previous version of Rails to be supported

16. Delete any files for old Rails versions that are no longer supported - "dummy" apps and the corresponding `gemfiles` Gemfile.

17. Update the Circle CI badge label in this README to reflect the newly supported Rails version.

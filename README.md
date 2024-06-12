# Devise Secure Password Extension

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

The __Devise Secure Password Extension__ is a user account password policy enforcement gem that can be
added to a Rails project to enforce password policies. The gem is implemented as an extension to the Rails
[devise](https://github.com/plataformatec/devise) authentication solution gem and requires that __devise__ is installed
as well.

## Overview

The __Devise Secure Password Extension__ is composed of the following modules:

- __password_has_required_content__: require that passwords consist of a specific number (configurable) of letters,
  numbers, and special characters (symbols)
- __password_disallows_frequent_reuse__: prevent the reuse of a number (configurable) of previous passwords when a user
  changes their password
- __password_disallows_frequent_changes__: prevent the user from changing their password more than once within a time
  duration (configurable)
- __password_requires_regular_updates__: require that a user change their password following a time duration
  (configurable)

## Compatibility

The goal of this project is to provide compatibility for officially supported stable releases of [Ruby](https://www.ruby-lang.org/en/downloads/)
and [Ruby on Rails](http://guides.rubyonrails.org/maintenance_policy.html). More specifically, the following releases
are currently supported by the __Devise Secure Password Extension__:

- Ruby on Rails: __6.1.x__, __7.0.x__
- Ruby: __3.1.x__, __3.2.x__, __3.3.x__

### Updating to a New Rails Version

This gem uses so-called "dummy" apps in the specs to verify compatibility with a major/minor version of Rails.  Adding a new major/minor version of Rails requires us to add a new "dummy" app in the spec folder, and a corresponding Gemfile in the gemfiles directory.  While manual, this process is relatively straightforward:

1. Create a new Rails app in the directory `spec/rails_<major>_<minor>` by using the Rails generator for that version, ensuring you skip Git setup.  (e.g. `cd spec; rails _6.0.3.6_ new rails-app-6_0 --skip-git`)
2. Move the Gemfile from the newly created app to the `gemfiles` directory and rename it with the major/minor version (e.g. `mv spec/rails_6_1/Gemfile gemfiles/rails_6_1.gemfile`)
3. Update the Gemfile to include the Rails target and gemspec immediately beneath the source declarations, like this:

```ruby
source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ENV['RAILS_TARGET'] ||= '6.1'

gemspec path: '../'
```

4. Add `gem 'shoulda-matchers'` under the test group in the new Gemfile
5. Ensure you can bundle by running `bundle` with the `BUNDLE_GEMFILE` variable set to the new Gemfile (i.e. `BUNDLE_GEMFILE=gemfiles/rails_6_1.gemfile bundle`).  This should run successfully - fix as needed.
6. Copy the file `config/initializers/devise.rb` from an existing "dummy" app to the same location in the new app.
7. Copy the file `config/routes.rb` from an existing "dummy" app to the same location in the new app.
8. Copy the contents of the `db/migrate` directory from an existing "dummy" app to the same location in the new app.  Copy the `db/schema.rb` and `db/test.sqlite3` as well
9. Copy the `app/controllers/static_pages_controller.rb` from an existing "dummy" app to the same location in the new app.
10. Copy the `app/models/isolated` directory and the `app/models/user.rb` file from an existing "dummy" app to the same location in the new app.
11. Copy the `app/views/static_pages` directory from an existing "dummy" app to the same location in the new app.
12. Update the `app/views/layouts/application.html.erb` in the new app to have the same `<body>` content and `<title>` as the same file in an existing "dummy" app.
13. At this point you should be able to run specs.  (i.e. `BUNDLE_GEMFILE=gemfiles/rails_6_1.gemfile bundle exec rake`).  Run specs and fix version specific issues, taking care to maintain backwards compatibility with supported versions.
14. You should also run Rubocop (i.e. `BUNDLE_GEMFILE=gemfiles/rails_6_1.gemfile bundle exec rubocop`) and fix whatever issues are reported (again, maintaining backwards compatibility)
15. In the `.circleci/config.yml` file update the `current_rails_gemfile` and `previous_rails_gemfile` to reference the new version and the previous version of Rails to be supported
16. Delete any files for old Rails versions that are no longer supported - "dummy" apps and the corresponding `gemfiles` Gemfile.
17. Update the Circle CI badge label in this README to reflect the newly supported Rails version.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise',                 '~> 4.8'
gem 'devise-secure_password', '~> 2.0'
```

And then execute:

```shell
prompt> bundle
```

Or install it yourself as:

```shell
prompt> gem install devise-secure_password
```

Finally, run the generator:

```shell
prompt> rails generate devise:secure_password:install
```

## Usage

### Configuration

The __Devise Secure Password Extension__ exposes configuration parameters as outlined below. Commented out configuration
parameters reflect the default settings.

```ruby
Devise.setup do |config|
  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_has_required_content
  #
  # Configure password content requirements including the number of uppercase,
  # lowercase, number, and special characters that are required. To configure the
  # minimum and maximum length refer to the Devise config.password_length
  # standard configuration parameter.

  # The number of uppercase letters (latin A-Z) required in a password:
  # config.password_required_uppercase_count = 1

  # The number of lowercase letters (latin A-Z) required in a password:
  # config.password_required_lowercase_count = 1

  # The number of numbers (0-9) required in a password:
  # config.password_required_number_count = 1

  # The number of special characters ( !@#$%^&*()_+-=[]{}|'"/\.,`<>:;?~) required in a password:
  # config.password_required_special_character_count = 1

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_disallows_frequent_reuse
  #
  # The number of previously used passwords that can not be reused:
  # config.password_previously_used_count = 8

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_disallows_frequent_changes
  #     *Requires* password_disallows_frequent_reuse
  #
  # The minimum time that must pass between password changes:
  # config.password_minimum_age = 1.days

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_requires_regular_updates
  #     *Requires* password_disallows_frequent_reuse
  #
  # The maximum allowed age of a password:
  # config.password_maximum_age = 180.days
end
```

>NOTE: Password policy defaults have been selected as a middle-of-the-road combination based on published
recommendations by [Microsoft](https://technet.microsoft.com/en-us/library/ff741764.aspx) and
[Carnegie Mellon University](https://www.cmu.edu/iso/governance/guidelines/password-management.html). It is up to
__YOU__ to verify the default settings and make adjustments where necessary.

Enable the __Devise Secure Password Extension__ enforcement in your Devise model(s):

```ruby
devise :password_has_required_content, :password_disallows_frequent_reuse,
       :password_disallows_frequent_changes, :password_requires_regular_updates
```

Usually, you would append these after your selection of Devise modules. So your configuration will more likely look like
the following:

```ruby
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_has_required_content, :password_disallows_frequent_reuse,
         :password_disallows_frequent_changes, :password_requires_regular_updates
   ...
   <YOUR USER MODEL CONTENT FOLLOWS>
end
```

>NOTE: Both `:password_disallows_frequent_changes` and `:password_requires_regular_updates` are dependent upon the
previous passwords memorization implemented by the `:password_disallows_frequent_reuse` module.

### Database migration

The following database migration needs to be applied:

```shell
prompt> rails generate migration create_previous_passwords salt:string encrypted_password:string user:references
```

Edit the resulting file to disallow null values for the hash,add indexes for both hash and user_id fields, and to also
add the timestamp (created_at, updated_at) fields:

```ruby
class CreatePreviousPasswords < ActiveRecord::Migration[5.1]
  def change
    create_table :previous_passwords do |t|
      t.string :salt, null: false
      t.string :encrypted_password, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end

    add_index :previous_passwords, :encrypted_password
    add_index :previous_passwords, [:user_id, :created_at]
  end
end

```

And then:

```shell
prompt> bundle exec rake db:migrate
```

### Displaying errors

You will likely want to display errors, produced as a result of secure password enforcement violations, to your users.
Errors are available via the `User.errors` array and via the `devise_error_messages!` method. An example usage follows
and is taken from the default password `edit.html.erb` page:

```erb
<%= form_for(resource, as: resource_name, url: [resource_name, :password_with_policy], html: { method: :put }) do |f| %>
  <% if resource.errors.full_messages.count.positive? %>
    <%= devise_error_messages! %>
  <% end %>

  <p><%= f.label :current_password, 'Current password' %><br />
  <%= f.password_field :current_password %></p>

  <p><%= f.label :password, 'New password' %><br />
  <%= f.password_field :password %></p>

  <p><%= f.label :password_confirmation, 'Password confirmation' %><br />
  <%= f.password_field :password_confirmation %></p>

  <p><%= f.submit 'Update' %></p>
<% end %>
```

<a name="running-tests"></a>

## Running Tests

This document assumes that you already have a [functioning ruby install](https://rvm.io/).

### Default Rails target

The __Devise Secure Password Extension__ provides compatibility for officially supported stable releases of Ruby on
Rails. To configure and test the default target (the most-recent supported Rails release):

```bash
prompt> bundle
prompt> bundle exec rake
```

### Selecting an alternate Rails target

To determine the Ruby on Rails versions supported by this release, run the following commands:

```bash
prompt> gem install flay ruby2ruby rubocop rspec
prompt> rake test:spec:targets

Available Rails targets: 7.0, 6.1
```

Reconfigure the project by specifying the correct Gemfile when running bundler, followed by running tests:

```bash
prompt> BUNDLE_GEMFILE=gemfiles/rails_7_0.gemfile bundle
prompt> BUNDLE_GEMFILE=gemfiles/rails_7_0.gemfile bundle exec rake
```

The only time you need to define the `BUNDLE_GEMFILE` environment variable is when testing a non-default target.

### Testing with code coverage (SimpleCov)

SimpleCov tests are enabled by defining the `test:spec:coverage` rake task:

```bash
prompt> bundle exec rake test:spec:coverage
```

A brief summary will be output at the end of the run but a more extensive eport will be saved in the `coverage`
directory (under the top-level project directory).

### Testing with headless Chrome

You will need to install the [ChromeDriver >= v2.3.4](https://sites.google.com/a/chromium.org/chromedriver/downloads)
for testing.

```bash
prompt> brew install chromedriver
```

You can always install [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) by downloading and then
unpacking into the `/usr/local/bin` directory.

#### Automated screenshots on failure

The [capybara-screenshot gem](https://github.com/mattheworiordan/capybara-screenshot) supports automated screenshot
captures on failing tests but this will only take place for tests that have JavaScript enabled. You can temporarily
modify an example by setting `js: true` as in the following example:

```ruby
context 'when minimum age enforcement is enabled', js: true do
...
end
```

Do not submit pull requests with this setting enabled where it wasn't enabled previously.

### Testing inside the spec/rails-app-X_y_z

To debug from inside of the dummy rails-app you will need to first install the rails bin stubs and then perform a db
migration:

```bash
prompt> cd spec/rails-app-X_y_z
prompt> rake app:update:bin
prompt> RAILS_ENV=development bundle exec rake db:migrate
```

Remember, the dummy app is not meant to be a full featured rails app: there is just enough functionality to test the
gem feature set.

### Running benchmarks

Available benchmarks can be run as follows:

```bash
prompt> bundle exec rake test:benchmark
```

Benchmarks are run within an RSpec context but are not run along with other tests as benchmarks merely seek to measure
performance and not enforce set performance targets.

### Screenshots

Failing tests that invoke the JavaScript driver will result in both the failing html along with a screenshot of the
page output to be saved in the `spec/rails-app-X_y_z/tmp/capybara` snapshot directory.

>NOTE: On __circleci__ the snapshots will be captured as artifacts.

The snapshot directory will be pruned automatically between runs.

## Docker

This repository includes a [Dockerfile](https://docs.docker.com/engine/reference/builder/) to facilitate testing in and
using [Docker](https://www.docker.com/).

To start the container simply build and launch the image:

```bash
prompt> docker build -t secure-password-dev .
prompt> docker run -it --rm secure-password-dev /bin/bash
```

The above `docker run` command will start the container, connect you to the command line within the project home
directory where you can issue the tests as documented in the [Running Tests](#running-tests) section above. When you exit
the shell, the container will be removed.

### Running tests in a Docker container

The Docker container is derived from the latest [circleci/ruby](https://hub.docker.com/r/circleci/ruby/) image. It is
critical that you update the bundler inside of the Docker image as the `circleci` user (i.e. the default user) before
initiating any development work including tests.

```bash
prompt> gem update bundler
```

#### Updating test.sqlite3.db

To update or generate a `db/test/sqlite3.db` database file:

```bash
prompt> cd spec/rails-app-X_y_z
prompt> bundle install
prompt> rake app:update:bin
prompt> RAILS_ENV=test bundle exec rake db:migrate
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/valimail/devise-secure_password. This project
is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Basic guidelines for contributors

1 Fork it

2 Create your feature branch (`git checkout -b my-new-feature`)

3 Commit your changes (`git commit -am 'Add some feature'`)

4 Push to the branch (`git push origin my-new-feature`)

5 Create new Pull Request

>NOTE: Contributions should always be based on the `master` branch. You may be asked to [rebase](https://git-scm.com/docs/git-rebase)
your contributions on the tip of the `master` branch, this is normal and is to be expected if the `master` branch has
moved ahead since your pull request was opened, discussed, and accepted.

## License

The __Devise Secure Password Extension__ gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the __Devise Secure Password Extension__ project’s codebases and issue trackers is expected to
follow the [code of conduct](https://github.com/valimail/devise-secure_password/blob/master/CODE_OF_CONDUCT.md).

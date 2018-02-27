# Devise Secure Password Extension

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

The __Devise Secure Password Extension__ is a user account password policy enforcement gem that can be
added to a Rails project to enforce password policies. The gem is implemented as an extension to the Rails
[devise](https://github.com/plataformatec/devise) authentication solution gem and requires that __devise__ is installed
as well.

## Build Status

| Service    | rails 5.1.4 |
|:-----------|:-----------:|
| Circle CI  | [![Circle CI](https://circleci.com/gh/ValiMail/devise-secure_password/tree/master.svg?style=shield&circle-token=cd173d5f9d2944a9b14737c2d4339b20b08565cf)]() |

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

- Ruby on Rails: __5.1.Z__, __5.0.Z__ (current and previous stable release)
- Ruby: __2.5.0__, __2.4.3__ (current and previous stable release)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise',                 '~> 4.2'
gem 'devise-secure_password', '~> 1.0.0'
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

  # Passwords consist of at least one uppercase letter (latin A-Z):
  # config.password_required_uppercase_count = 1

  # Passwords consist of at least one lowercase characters (latin a-z):
  # config.password_required_lowercase_count = 1

  # Passwords consist of at least one number (0-9):
  # config.password_required_number_count = 1

  # Passwords consist of at least one special character (!@#$%^&*()_+-=[]{}|'):
  # config.password_required_special_character_count = 1

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_disallows_frequent_reuse
  #
  # Passwords cannot be reused. A user's last 24 password hashes are saved:
  # config.password_previously_used_count = 24

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_disallows_frequent_changes
  #     *Requires* password_disallows_frequent_reuse
  #
  # Passwords cannot be changed more frequently than once per day:
  # config.password_minimum_age = 1.day

  # ==> Configuration for the Devise Secure Password extension
  #     Module: password_requires_regular_updates
  #     *Requires* password_disallows_frequent_reuse
  #
  # Passwords must be changed every 60 days:
  # config.password_maximum_age = 60.days
end
```

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

Edit the resulting file to disallow null values for the hash and to add indexes for both hash and user_id fields:

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

### Local installation

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

>WARNING: These instructions need to be vetted. Refer to `Running Tests` below for the current testing workflow.

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
prompt> gem install flay ruby2ruby rubucop rspec
prompt> rake test:spec:targets

Available Rails targets: 5.0.6, 5.1.4
```

Reconfigure the project by specifying the correct Gemfile when running bundler, followed by running tests:

```bash
prompt> BUNDLE_GEMFILE=gemfiles/rails-5_0_6.gemfile bundle
prompt> BUNDLE_GEMFILE=gemfiles/rails-5_0_6.gemfile bundle exec rake
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

>NOTE: __ChromeDriver__ < 2.33 has a bug for testing clickable targets; therefore, install >= 2.3.4.

You can always install [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) by downloading and then
unpacking into the `/usr/local/bin` directory.

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

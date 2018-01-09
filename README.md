# Devise Password Policy Extension

[![License](http://img.shields.io/badge/license-MIT-yellowgreen.svg)](#license)

The __Devise Password Policy Extension__ (or __DPPE__) is a user account password policy enforcement gem that can be
added to a Rails project to enforce password policies. The gem is implemented as an extension to the Rails
[devise](https://github.com/plataformatec/devise) authentication solution gem and requires that __devise__ is installed
as well.

## Build Status

| Service    | rails 4.2.10 | rails 5.1.4 |
|:-----------|:------------:|:-----------:|
| Circle CI  | [![Build Status](https://img.shields.io/badge/build-none-lightgrey.svg)]() | [![Circle CI](https://circleci.com/gh/ValiMail/devise_password_policy_extension/tree/master.svg?style=shield&circle-token=a752164d3935bb6ad865ef67012c2c0099730d30)]() |

## Overview

The __Devise Password Policy Extension__ is composed of the following modules:

- __password_content_enforcement__: require that passwords consist of a specific number of letters, numbers, and special 
  characters (symbols)

The following additional modules are currently under development:

- __password_frequent_reuse_prevention__
- __password_frequent_change_prevention__
- __password_regular_update_enforcement__

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise',                           '~> 4.2'
gem 'devise_password_policy_extension', '~> 1.0.0'
```

And then execute:

```shell
prompt> bundle
```

Or install it yourself as:

```shell
prompt> gem install devise_password_policy_extension
```

Finally, run the generator:

```shell
prompt> rails generate devise_password_policy_extension:install
```

## Usage

### Configuration

The __Devise Password Policy Extension__ exposes configuration parameters as outlined below. Commented out configuration
parameters reflect the default settings.

```ruby
Devise.setup do |config|
  # ==> Configuration for the Devise Password Policy Extension (DPPE)
  #     DPPE Module: password_content_enforcement
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

  # ==> Configuration for the Devise Password Policy Extension (DPPE)
  #     DPPE Module: password_frequent_reuse_prevention
  #
  # Passwords cannot be reused. A user's last 24 password hashes are saved:
  # config.password_previously_used_count = 24

  # ==> Configuration for the Devise Password Policy Extension (DPPE)
  #     DPPE Module: password_frequent_change_prevention
  #     *Requires* password_frequent_reuse_prevention module
  #
  # Passwords cannot be changed more frequently than once per day:
  # config.password_minimum_age = 1.day

  # ==> Configuration for the Devise Password Policy Extension (DPPE)
  #     DPPE Module: password_regular_update_prevention
  #     *Requires* password_frequent_reuse_prevention module
  #
  # Passwords must be changed every 60 days:
  # config.password_maximum_age = 60.days

end
```

Enable the __Devise Password Policy Extension__ enforcement in your Devise model(s):

```ruby
devise :password_content_enforcement, :password_frequent_reuse_prevention
```

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
prompt> rails db:migrate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

>NOTE: The `bin/setup` command will install a git pre-commit hook. It is __absolutely critical__ that you install this
hook. See [Git hooks installation](#git-hooks) to install the hook manually.

### Local installation

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

>WARNING: These instructions need to be vetted. Refer to `Running Tests` below for the current testing workflow.

<a name="git-hooks"></a>

### Git hooks intallation

Development of the __Devise Password Policy Extension__ relies on a continuous integration environment provided by
[circleci](https://circleci.com/). To enable caching of build resources, checksums are calculated from a lock file. To
enable this functionality a [git pre-commit hook](https://git-scm.com/docs/githooks) must be enabled in your local repo:

```shell
prompt> git config core.hooksPath .githooks
```

With the hook in place, each time you make a commit additional `Gemfile.lock.ci` files will be generated when necessary.

<a name="running-tests"></a>

## Running Tests

This document assumes that you already have a [functioning ruby install](https://rvm.io/).

To prepare the tests run the following commands:

```bash
prompt> cd spec/rails-app
prompt> gem install bundler && bundle install --jobs=4 --retry=3 --path ../../vendor/bundle
prompt> RAILS_ENV=test bundle exec rake db:migrate
```

Now on the project root run the following commands:

```bash
prompt> gem install bundler && bundle install --jobs=4 --retry=3 --path vendor/bundle
prompt> bundle exec rspec spec/
```

### Testing with Headless Chrome

You will need to install the [ChromeDriver >= v2.3.4](https://sites.google.com/a/chromium.org/chromedriver/downloads)
for testing.

```bash
prompt> brew install chromedriver
```

>NOTE: __ChromeDriver < 2.33 has a bug for testing clickable targets; therefore, install >= 2.3.4.

You can always install [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) by downloading and then
unpacking into the `/usr/local/bin` directory.

### Testing inside the spec/rails-app

To debug from inside of the dummy rails-app you will need to first install the rails bin stubs and then perform a db
migration:

```bash
prompt> cd spec/rails-app
prompt> rake app:update:bin
prompt> RAILS_ENV=development bundle exec rake db:migrate
```

Remember, the dummy app is not meant to be a full featured rails app: there is just enough functionality to test the
gem feature set.

### Screenshots

Failing tests that invoke the JavaScript driver will result in both the failing html along with a screenshot of the
page output to be saved in the `spec/rails-app/tmp/capybara` snapshot directory.

>NOTE: On __circleci__ the snapshots will be captured as artifacts.

The snapshot directory will be pruned automatically between runs.

## Docker

This repository includes a [Dockerfile](https://docs.docker.com/engine/reference/builder/) to facilitate testing in and
using [Docker](https://www.docker.com/).

To start the container simply build and launch the image:

```bash
prompt> docker build -t dppe-dev .
prompt> docker run --rm -it dppe-dev /bin/bash
```

The above `docker run` command will start the container, connect you to the command line within the project home
directory where you can issue the tests as documented in the [Running Test](#running-tests) section above. When you exit
the shell, the container will be removed.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/valimail/devise_password_policy_extension.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

### Basic guidelines for contributors

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

>NOTE: Contributions should always be based on the `develop` branch. You may be asked to [rebase](https://git-scm.com/docs/git-rebase)
your contributions on the tip of the `develop` branch, this is normal and is to be expected if the `develop` branch has
moved ahead since your pull request was opened, discussed, and accepted.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DevisePasswordPolicyExtension project’s codebases, issue trackers, chat rooms and mailing
lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/devise_password_policy_extension/blob/master/CODE_OF_CONDUCT.md).

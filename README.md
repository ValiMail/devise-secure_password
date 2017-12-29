# Devise Password Policy Extension

The __Devise Password Policy Extension__ (or __DPPE__) is a user account password policy enforcement gem that can be
added to a Rails project to enforce password policies. The gem is implemented as an extension to the Rails
[devise](https://github.com/plataformatec/devise) authentication solution gem and requires that __devise__ is installed
as well.

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

## Running Tests

Outside of a [functioning ruby install](https://rvm.io/), you will need the [Bundler](https://github.com/bundler/bundler/)
gem:

```bash
prompt> gem install bundler
```

To prepare the tests run the following commands:

```bash
prompt> cd spec/rails-app
prompt> bundle install
prompt> RAILS_ENV=test bundle exec rake db:migrate
```

Now on the project root run the following commands:

```bash
prompt> bundle exec rspec spec/
```

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

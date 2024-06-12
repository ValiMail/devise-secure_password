# Changelog: devise-secure_password

## 2.1.0 / 2024-06-02

* Various CircleCI updates.
* Update README for (Rails, Ruby) versions tested.
* Drop support for old Ruby and Rails; add support for Rails 7.0.
* Implement support to additional special characters. #71
* several years worth of dependabot updates

## 1.1.0 / 2018-08-08

With this release, the __devise-secure_password__ gem drops official support for Rails < 5.1. Supported versions are now
Rails 5.2 (current release) and Rails 5.1 (last release).

* Update README for Rails versions tested (5.2, 5.1).
* Update circleci config for Ruby and Rails versions.
* Update default dev build to Rails 5.2.
* Add test support for Rails 5.2.
* Remove test support for Rails 5.0.
* Update Dockerfile.prev ruby to 2.4.4.
* Update Dockerfile ruby to 2.5.1.
* Sort rake targets task list output.
* Add Codecov.io for coverage tracking

## 1.0.8 / 2018-06-15

* Update README for ruby versions tested (2.5.1, 2.4.4).
* Update README for target reconfig instructions.
* Update README for test screenshot generation.
* Fix grammar for error messages.
* Fix empty new passwords skipping validation.
* Add tests for invalid empty and current passwords.
* Add total string length counting to character_counter.
* Add password confirmation equality validator.
* Add length validations to password fields.
* Add update_action hidden field to forced password change form.
* Refactor passwords_with_policy controller.

## 1.0.7 / 2018-05-25

* Fix specs to use appropriate Rails version
* Update configuration to not include patch version for Rails
* Manage expiration in session to remove incompatability with authentication extensions

## 1.0.6 / 2018-05-04

* Fix scoping for previous passwords returned through associations.

## 1.0.5 / 2018-04-30

* Update rails-app-5_1_4 config for SQLite3Adapter changes.
* Update previous_password default_scope to be based on id.
* Configure more reasonable defaults.
* Update README regarding defaults and a users need to verify.
* Update README to include section on Displaying errors.
* Revert password freshness algorithm from 1.0.4.

## v1.0.4 / 2018-04-28

* Fix for ignored redirect on expired passwords.
* Change password freshness algorithm to consider updated records.

## v1.0.3 / 2018-04-23

* Skip enforcement checks unless User model requires a password.
* Update migration code to accomodate changes in underlying ActiveRecord.

## v1.0.2 / 2018-03-14

* Update the default configuration to be less strict - users can enable individual features.
* Do not override global timeago strings.

## v1.0.1 / 2018-03-14

* Fix the special character configuration parameter name and add specs.

## v1.0.0 / 2018-03-07

* Update license.
* Refactor to simplify install and test commands.

## v0.9.4 / 2018-01-24

* Fix typos in README.
* Update circleci badge token.
* Rename modules according to convention for Rails concerns.
* Implement code coverage.
* Support multiple rails versions for testing.
* Rename password_regular_update_enforcement_controller to dppe_passwords_controller.

## v0.9.3 / 2018-01-09

* Implement password regular update

## v0.9.2 / 2018-01-02

* Implement password frequent change enforcement.

## v0.9.1 / 2017-12-29

* Implement password frequent reuse enforcement.

## v0.9.0 / 2017-12-26

* Implement password content enforcement.

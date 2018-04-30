# Changelog: devise-secure_password

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
* [VME-1693] Refactor to simplify install and test commands.

## v0.9.4 / 2018-01-24

* [VME-1661] Fix typos in README.
* [VME-1646] Update circleci badge token.
* [VME-1646] Rename modules according to convention for Rails concerns.
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

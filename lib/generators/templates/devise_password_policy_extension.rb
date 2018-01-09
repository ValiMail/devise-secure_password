# frozen_string_literal: true

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

module Isolated
  class User < ApplicationRecord; end

  class UserFrequentChangesBad < User
    #
    # Should trigger a ConfigurationError:
    #   - :password_disallows_frequent_changes enabled
    #   - :password_disallows_frequent_reuse missing
    #
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_disallows_frequent_changes
  end
end

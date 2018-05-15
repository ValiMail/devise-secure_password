module Isolated
  class User < ApplicationRecord; end

  class UserFrequentChangesBadConfig < User
    #
    # Should trigger a ConfigurationError:
    #   - password_minimum_age is invalid type
    #
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_disallows_frequent_changes

    class << self
      def password_minimum_age
        10
      end
    end

  end
end

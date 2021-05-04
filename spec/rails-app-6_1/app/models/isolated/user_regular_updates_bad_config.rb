module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdatesBadConfig < User
    #
    # Should trigger a ConfigurationError:
    #   - password_maximum_age is invalid type
    #
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_disallows_frequent_reuse,
          :password_requires_regular_updates

    class << self
      def password_maximum_age
        10
      end
    end

  end
end

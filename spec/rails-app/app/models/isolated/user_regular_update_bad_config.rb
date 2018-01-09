module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdateBadConfig < User
    #
    # Should trigger a ConfigurationError:
    #   - password_maximum_age is invalid type
    #
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_frequent_reuse_prevention,
          :password_regular_update_enforcement

    class << self
      def password_maximum_age
        10
      end
    end

  end
end

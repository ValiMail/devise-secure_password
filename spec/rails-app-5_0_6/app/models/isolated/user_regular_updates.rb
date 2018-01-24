module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdates < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_has_required_content,
          :password_disallows_frequent_reuse,
          :password_requires_regular_updates
  end
end

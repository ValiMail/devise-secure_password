module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdate < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_content_enforcement,
          :password_frequent_reuse_prevention,
          :password_regular_update_enforcement
  end
end

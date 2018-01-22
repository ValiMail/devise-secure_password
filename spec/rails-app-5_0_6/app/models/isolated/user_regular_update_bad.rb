module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdateBad < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_content_enforcement,
          :password_regular_update_enforcement
  end
end

module Isolated
  class User < ApplicationRecord; end

  class UserRegularUpdatesBad < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_has_required_content,
          :password_requires_regular_updates
  end
end

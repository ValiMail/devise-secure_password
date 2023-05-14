module Isolated
  class User < ApplicationRecord; end

  class UserFrequentReuse < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_has_required_content,
          :password_disallows_frequent_reuse
  end
end

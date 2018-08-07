module Isolated
  class User < ApplicationRecord; end

  class UserFrequentChanges < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_has_required_content,
          :password_disallows_frequent_reuse,
          :password_disallows_frequent_changes
  end
end

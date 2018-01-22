module Isolated
  class User < ApplicationRecord; end

  class UserFrequentChange < User
    devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :trackable, :validatable,
          :password_content_enforcement,
          :password_frequent_reuse_prevention,
          :password_frequent_change_prevention
  end
end

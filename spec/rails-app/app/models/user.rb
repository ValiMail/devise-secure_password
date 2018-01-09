class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_content_enforcement,
         :password_frequent_reuse_prevention,
         :password_frequent_change_prevention,
         :password_regular_update_enforcement
end

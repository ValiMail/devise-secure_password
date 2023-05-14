class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_has_required_content,
         :password_disallows_frequent_reuse,
         :password_disallows_frequent_changes,
         :password_requires_regular_updates
end

module Isolated
  class User < ApplicationRecord; end

  class UserContent < User
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable,
           :recoverable, :rememberable, :trackable, :validatable,
           :password_content_enforcement
  end
end

class UserFrequentReuse < User
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :password_content_enforcement,
         :password_frequent_reuse_prevention
end

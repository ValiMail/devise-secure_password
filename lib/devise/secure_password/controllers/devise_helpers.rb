module Devise
  module SecurePassword
    module Controllers
      module DeviseHelpers
        extend ActiveSupport::Concern

        class ::DeviseController
          alias devise_sign_in sign_in

          protected

          def sign_in(*args)
            devise_sign_in(*args).tap do
              set_devise_secure_password_expired! if warden_user_has_password_expiration?
            end
          end
        end
      end
    end
  end
end

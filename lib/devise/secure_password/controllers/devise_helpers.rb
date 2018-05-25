module Devise
  module SecurePassword
    module Controllers
      module DeviseHelpers
        extend ActiveSupport::Concern

        class ::DeviseController
          alias devise_sign_in sign_in

          protected

          def sign_in(*args)
            devise_sign_in(*args).tap do |signed_in|
              if warden.user && warden.user.respond_to?(:password_expired?)
                session[:devise_secure_password_expired] = warden.user.password_expired?
              end
            end
          end
        end
      end
    end
  end
end

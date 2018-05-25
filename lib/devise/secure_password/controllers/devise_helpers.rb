module Devise
  module SecurePassword
    module Controllers
      module DeviseHelpers
        extend ActiveSupport::Concern

        class ::DeviseController
          alias devise_sign_in sign_in

          protected

          def sign_in(*args)
            if warden.session(args.first).has_key? 'secure_password_expired'
              session[:devise_secure_password_expired] = warden.session(args.first)['secure_password_expired']
            end
          rescue Warden::NotAuthenticated
          ensure
            devise_sign_in(*args)
          end
        end
      end
    end
  end
end

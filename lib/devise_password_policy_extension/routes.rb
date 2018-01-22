module ActionDispatch
  module Routing
    class Mapper
      protected

      def devise_passwords_with_policy(mapping, controllers)
        resource :password_with_policy, only: %i(edit update), path: mapping.path_names[:change_password], controller: controllers[:passwords_with_policy]
      end
    end
  end
end

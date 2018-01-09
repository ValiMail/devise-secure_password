module ActionDispatch
  module Routing
    class Mapper
      protected

      def devise_password_regular_update_enforcement(mapping, controllers)
        resource :password_regular_update_enforcement, only: %i(edit update), path: mapping.path_names[:password_regular_update_enforcement], controller: controllers[:password_regular_update_enforcement]
      end
    end
  end
end

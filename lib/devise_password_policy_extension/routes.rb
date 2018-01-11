module ActionDispatch
  module Routing
    class Mapper
      protected

      def devise_dppe_passwords(mapping, controllers)
        resource :dppe_password, only: %i(edit update), path: mapping.path_names[:change_password], controller: controllers[:dppe_passwords]
      end
    end
  end
end

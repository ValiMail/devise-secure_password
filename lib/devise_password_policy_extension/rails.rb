module DevisePasswordPolicyExtension
  class Engine < ::Rails::Engine
    # ActiveSupport.on_load(:action_controller) do
    #   include DevisePasswordPolicyExtension::Controllers::Helpers
    # end

    # if Rails.version > "5"
    #   ActiveSupport::Reloader.to_prepare do
    #     DevisePasswordPolicyExtension::Patches.apply
    #   end
    # else
    #   ActionDispatch::Callbacks.to_prepare do
    #     DevisePasswordPolicyExtension::Patches.apply
    #   end
    # end
  end
end

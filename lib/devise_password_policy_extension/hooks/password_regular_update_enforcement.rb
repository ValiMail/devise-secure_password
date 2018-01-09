Warden::Manager.after_authentication do |user, warden, options|
  if user.respond_to?(:password_expired?)
    warden.session(options[:scope])[:dppe_password_expired] = user.password_expired?
  end
end

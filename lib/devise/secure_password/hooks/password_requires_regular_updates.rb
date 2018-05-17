Warden::Manager.after_authentication do |user, warden, options|
  if user.respond_to?(:password_expired?)
    warden.session(options[:scope])[:secure_password_expired] = user.password_expired?
  end
end

Warden::Manager.after_fetch do |user, warden, options|
  if user.respond_to?(:password_expired?) && !warden.session[:secure_password_expired]
    warden.session(options[:scope])[:secure_password_expired] = user.password_expired?
  end
end

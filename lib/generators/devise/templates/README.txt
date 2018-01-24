===============================================================================

Additional setup required:

  1. Verify that default settings in config/initializers/secure_password.rb
     are suitable for your purposes.

  2. Enable secure_password modules by adding all of them or just the ones you
     want to your User model. See the README for instructions.

  3. Perform a database migration to create the PreviousPasswords table. This
     step is not necessary if you only intend to enable the password content
     module (password_has_required_content). See the README for instructions.

  4. Add flash messages in app/views/layouts/application.html.erb.
     For example:

       <p class="notice"><%= notice %></p>
       <p class="alert"><%= alert %></p>

===============================================================================

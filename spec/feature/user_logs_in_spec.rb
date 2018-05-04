require 'spec_helper'

RSpec.describe 'User logs in', type: :feature do
  let(:password) { 'Bubb1234%$#!' }
  let(:user) do
    User.new(
      email:                 'betty@rubble.com',
      password:              password,
      password_confirmation: password
    )
  end

  context 'with a password older than password_maximum_age', js: true do
    before do
      user.save
      last_password = user.previous_passwords.first
      last_password.created_at = Time.zone.now - User.password_maximum_age
      last_password.save
      visit '/users/sign_in'
    end

    scenario 'redirected to the change password page' do
      expect(page).to have_content(/Log in/i)
      expect(page).to have_selector('input[type="submit"]')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Change your password/i)
      within '#error_explanation' do
        expect(page).to have_content 'Your password has expired'
      end

      expect(page).to have_selector('form.new_user')
      within 'form.new_user' do
        expect(page).to have_selector('label[for="user_current_password"]', text: /Current password/i)
        expect(page).to have_selector('input[type="password"]#user_current_password')
        expect(page).to have_selector('label[for="user_password"]', text: /New password/i)
        expect(page).to have_selector('input[type="password"]#user_password')
        expect(page).to have_selector('label[for="user_password_confirmation"]', text: /Confirm new password/i)
        expect(page).to have_selector('input[type="password"]#user_password_confirmation')
        expect(page).to have_selector('input[type="submit"][value="Change my password"]')
      end
    end
  end

  context 'with a password newer than password_maximum_age', js: true do
    before do
      user.save
      visit '/users/sign_in'
    end

    scenario 'is not redirected to change password page' do
      expect(page).to have_content(/Log in/i)
      expect(page).to have_selector('input[type="submit"]')
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      find(:xpath, ".//input[@type='submit' and @name='commit']").click

      expect(page).to have_content(/Signed in/i)
      expect(page).not_to have_selector('#error_explanation')
    end
  end
end

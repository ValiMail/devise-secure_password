require 'spec_helper'

RSpec.describe Devise::SessionsController, type: :controller do
  let(:password) { 'Bubb1234%$#!' }
  let(:user) do
    User.create(
      email: 'george@jetson.com',
      password: password,
      password_confirmation: password
    )
  end

  describe '#authenticate_secure_password_expired?' do
    subject { controller.authenticate_secure_password_expired? }

    before do
      sign_in user
      allow(controller.warden).to receive(:session).and_return('secure_password_expired' => true)
    end

    it 'does not prompt for password within a Devise controller' do
      expect(subject).to be false
    end
  end
end

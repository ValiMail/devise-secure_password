require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
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

    context 'warden is not authenticated' do
      it { is_expected.to be false }
    end

    context 'warden authenticated' do
      before { sign_in user }

      context 'w/o session' do
        before { allow(controller.warden).to receive(:session).and_return nil }

        it { is_expected.to be false }
      end

      context 'w/ session' do
        context 'no secure_password_expired information' do
          before { allow(controller).to receive(:session).and_return({}) }

          it { is_expected.to be false }
        end

        context 'devise_secure_password_expired is false' do
          before { allow(controller).to receive(:session).and_return(devise_secure_password_expired: false) }

          it { is_expected.to be false }
        end

        context 'devise_secure_password_expired is other value' do
          before { allow(controller).to receive(:session).and_return(devise_secure_password_expired: 'other value') }

          it { is_expected.to be false }
        end

        context 'secure_password_expired is true' do
          before { allow(controller).to receive(:session).and_return(devise_secure_password_expired: true) }

          it { is_expected.to be true }
        end
      end
    end
  end

  describe '#authenticate_secure_password!' do
    before do
      sign_in user
      allow(controller).to receive(:redirect_to)
    end

    context 'w/ expired' do
      before do
        controller.session[:devise_secure_password_expired] = true
        controller.authenticate_secure_password!
      end

      it 'redirects with alert flash' do
        expect(controller).to have_received(:redirect_to).with \
          :edit_user_password_with_policy, \
          alert: 'Your password has expired. Passwords must be changed every 6 months.'
      end
    end

    context 'w/ not expired' do
      before do
        controller.session[:devise_secure_password_expired] = 'other'
        controller.authenticate_secure_password!
      end

      it { expect(controller).not_to have_received(:redirect_to) }
    end
  end

  describe '#authenticate_secure_password_path' do
    subject { controller.authenticate_secure_password_path }

    context 'w/o warden.user' do
      it { is_expected.to be_nil }
    end

    context 'w/ warden.user' do
      before { sign_in user }

      it { is_expected.to eq :edit_user_password_with_policy }
    end
  end
end

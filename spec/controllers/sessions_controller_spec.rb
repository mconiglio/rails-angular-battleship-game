require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  include Rails.application.routes.url_helpers
  before { request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#create' do
    subject { post :create, { user: user, format: :json } }
    let(:user) { { email: email, password: password } }

    context 'without parameters' do
      let(:email) {}
      let(:password) {}

      it { should be_unauthorized }
      it { expect(JSON.parse(subject.body)['error']).to eq('You need to sign in or sign up before continuing.') }
    end

    context 'with parameters' do
      context 'with wrong parameters' do
        context 'without email' do
          let(:email) {}
          let(:password) { 'somepassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('You need to sign in or sign up before continuing.') }
        end

        context 'without password' do
          let(:email) { FactoryGirl.create(:user).email }
          let(:password) {}

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or password.') }
        end

        context 'with a wrong password' do
          let(:email) { FactoryGirl.create(:user).email }
          let(:password) { 'wrongpassword' }

          it { should be_unauthorized }
          it { expect(JSON.parse(subject.body)['error']).to eq('Invalid email or password.') }
        end
      end

      context 'with correct parameters' do
        let(:email) { FactoryGirl.create(:user).email }
        let(:password) { 'somepassword' }

        it { should be_success }
        it { expect(JSON.parse(subject.body)['email']).to eq(email) }
      end
    end
  end

  describe '#destroy' do
    subject { delete 'destroy', format: :json }

    context 'when logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it 'returns a success message' do
        sign_in(user, scope: :user)

        should be_success
        expect(JSON.parse(subject.body)['message']).to eq('Signed out successfully.')
      end
    end

    context 'when not logged' do
      it { expect(subject.status).to eql(204) }
    end
  end
end

require 'rails_helper'

RSpec.describe Admin::BaseController, type: :request do
  it '.authenticate_user!' do
    get '/admin'
    expect(response).not_to be_successful
  end

  describe '.authenticate_admin_user!' do
    it 'success' do
      signin_user(FactoryBot.create(:admin_user))
      get '/admin'
      expect(response).to be_successful
    end

    it 'not admin' do
      signin_user(FactoryBot.create(:user))
      get '/admin'
      expect(response).not_to be_successful
    end
  end
end

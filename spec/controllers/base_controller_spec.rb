require 'rails_helper'

RSpec.describe BaseController, type: :request do
  it 'GET /' do
    get '/'
    expect(response).to be_successful
    expect(response_meta_title).to be_present
  end

  it 'GET /robots.txt' do
    get '/robots.txt'
    expect(response).to be_successful
    expect(response.body).not_to match('<html')
    expect {
      get '/robots'
    }.to raise_error(ActionController::RoutingError)
  end
end

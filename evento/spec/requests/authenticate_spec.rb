require 'rails_helper'

RSpec.describe "Authenticate API" do
  let(:user) { FactoryGirl.create(:user) }

  context 'correct credentials are submitted' do
    it 'returns auth_token' do  
      post '/authenticate', params: { email: user.email, password: user.password }
      expect(json["auth_token"]).not_to eq(nil)
    end

    it 'returns code 200' do
      post '/authenticate', params: { email: user.email, password: user.password }
      expect(response.status).to eq(200)
    end
  end

  context 'incorrect credentials are submitted' do
    it 'returns error "Wrong credentials"' do
      post '/authenticate', params: { email: user.email, password: "wrong_password" }
      expect(json["error"]["authentication"]).to include("Wrong credentials")
    end
    
    it 'returns code 401' do  
      post '/authenticate', params: { email: user.email, password: "wrong_password" }
      expect(response.status).to eq(401)
    end
  end

  context 'auth_key has expired' do
    it 'returns new auth_key'
    it 'returns code 200'
  end
end

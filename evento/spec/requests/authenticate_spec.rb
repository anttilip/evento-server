require 'rails_helper'

RSpec.describe "Authenticate API" do
  let(:user) { FactoryGirl.create(:user) }

  context 'correct credentials are submitted' do
    it 'returns auth_token' do
      post '/authenticate', params: { email: user.email, password: user.password }
      expect(json["auth_token"]).not_to eq(nil)
    end

    it 'returns correct user' do
      post '/authenticate', params: { email: user.email, password: user.password }

      expect(json["user"]["id"]).to eq(user.id)
      expect(json["user"]["name"]).to eq(user.name)
      expect(json["user"]["email"]).to eq(user.email)
    end

    it 'does not return user\'s password_digest' do
      post '/authenticate', params: { email: user.email, password: user.password }
      expect(json["user"]["password_digest"]).to eq(nil)
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

    it 'does not return user' do
      post '/authenticate', params: { email: user.email, password: "wrong_password" }

      expect(response.status).to eq(401)
      expect(json["user"]).to eq(nil)
    end
  end

  context 'auth_key has expired' do
    it 'returns new auth_key'
    it 'returns code 200'
  end

  context "is authenticated" do
    let(:header) { { Authorization: JsonWebToken.encode(user_id: user.id), CONTENT_TYPE: "application/json" } }
    it "returns true if user is authenticated" do
      get '/authentication', headers: header

      expect(response.status).to eq(200)
      expect(json["authenticated"]).to eq(true)
      expect(json["user"]["id"]).to eq(user.id)
    end

    it "returns false if user is not authenticated" do
      get '/authentication' # no header

      expect(response.status).to eq(200)
      expect(json["authenticated"]).to eq(false)
      expect(json["user"]).to eq(nil)
    end
  end
end

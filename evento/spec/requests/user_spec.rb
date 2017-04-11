require 'rails_helper'

RSpec.describe "User API" do
  let(:user) { FactoryGirl.create(:user) }

  context 'without authentication' do

    it 'returns 401 when get /users/#{user.id}/events is requested' do
      get "/users/#{user.id}/events"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'returns 401 when get /users/-1/events is requested' do
      get "/users/-1/events"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'returns 401 when put /users/#{user.id}/ is requested' do
      put "/users/#{user.id}/"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'returns 401 when put /users/-1/ is requested' do
      put "/users/-1/"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'returns 401 when delete /users/#{user.id}/ is requested' do
      delete "/users/#{user.id}/"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'returns 401 when delete /users/-1/ is requested' do
      delete "/users/-1/"
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end
  end

  context 'with authentication' do      
    let(:header) { { Authorization: json["auth_token"], CONTENT_TYPE: "application/json" } }

    before(:each) do 
      post '/authenticate', params: { email: user.email, password: user.password }
      expect(response.status).to eq(200)  
      expect(json["auth_token"]).not_to eq(nil)
    end

    it 'gets events and returns 200 when get /users/#{user.id}/events is requested' do
      # create an event for the user
      event = FactoryGirl.create(:event, creator_id: user.id, category_id: FactoryGirl.create(:category).id)
      event.attendees << user

      get "/users/#{user.id}/events", headers: header
      expect(response.status).to eq(200)
      expect(json.length).to eq(1)
      expect(json[0]["title"]).to eq(event.title)
    end

    it 'returns 404 when get /users/-11/events is requested' do
        get "/users/-1/events", headers: header
        expect(response.status).to be(404)
    end

    it 'returns 401 when other users events are requested' do
      other_user = FactoryGirl.create(:user)

      get "/users/#{other_user.id}/events", headers: header
      expect(response.status).to eq(401)
      expect(json["error"]).to eq "Not Authorized"
    end

    it 'updates user and returns 200 when put /users/#{user.id}/ is requested' do
      put "/users/#{user.id}", params: { name: "NewName"}.to_json, headers: header

      user.reload
      expect(response.status).to eq(200)
      expect(user.name).to eq("NewName")
    end
    
    it 'returns 404 when put /users/-1/ is requested' do
      put "/users/-1", params: { name: "NewName" }.to_json, headers: header
      expect(response.status).to be(404)
    end

    it 'returns 422 when put /users/#{user.id} is requested with bad parameters' do
      put "/users/#{user.id}", params: { name: nil }.to_json, headers: header
      expect(response.status).to eq(422)
    end

    it 'returns 401 when authenticated user tries to update other user' do
      other_user = FactoryGirl.create(:user)
      put "/users/#{other_user.id}", params: { name: "NewName" }.to_json, headers: header
      expect(response.status).to eq(401)
    end

    it 'deletes user returns 200 when delete /users/#{user.id}/ is requested' do
      delete "/users/#{user.id}", headers: header
      expect(response.status).to eq(200)
    end

    it 'returns 404 when delete /users/-1/ is requested' do
      delete "/users/-1", headers: header
      expect(response.status).to be(404)
    end

    it 'returns 404 when delete /users/-1/ is requested' do
      delete "/users/-1", headers: header
      expect(response.status).to be(404)
    end

    it 'returns 401 when authenticated user tries to delete other user' do
      other_user = FactoryGirl.create(:user)
      delete "/users/#{other_user.id}", headers: header
      expect(response.status).to be(401)
    end
  end

  context 'public requests' do
    let(:json_header) { { CONTENT_TYPE: "application/json" } }

    it 'returns a list of users' do
      FactoryGirl.create_list(:user, 10)
      get '/users'

      # test for the 200 status-code
      expect(response).to be_success

      # check to make sure the right amount of users is returned
      expect(json.length).to eq(10)
    end

    it 'returns a single user' do
      get "/users/#{user.id}"

      # test for the 200 status-code
      expect(response).to be_success

      # check to make sure the right object is returned
      expect(json['id']).to eq(user.id)
      expect(json['name']).to eq(user.name)
      expect(json['email']).to eq(user.email)
    end

    it 'returns 404 when user is not found' do
      get "/users/-1"

      # test for the 404 status-code
      expect(response.status).to eq(404)
      expect(json['error']).to eq("Couldn't find User with 'id'=-1")
    end

    it 'returns 201 when get user is created with valid properties' do
      user = FactoryGirl.build(:user) # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      expect(response.status).to eq(201)
      expect(json["email"]).to eq user.email
      expect(json["name"]).to eq user.name
      expect(json).to have_key("id")
      expect(json).not_to have_key("password")
    end

    it 'saves the newly created user to database' do
      user = FactoryGirl.build(:user) # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      db_user = User.find(json['id']);
      expect(db_user.name).to eq user.name
      expect(db_user.email).to eq user.email
      expect(db_user.password).not_to eq user.password # Password should be hashed
    end

    it 'returns 422 if user is created without name' do
      user = FactoryGirl.build(:user, name: '') # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      expect(response.status).to eq(422)
      expect(User.where(email: user.email)).to be_empty # User was not added to database
    end

    it 'returns 422 if user is created without email' do
      user = FactoryGirl.build(:user, email: '') # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      expect(response.status).to eq(422)
      expect(User.where(email: user.email)).to be_empty # User was not added to database
    end

    it 'returns 422 if user is created without unique email' do
      user = FactoryGirl.build(:user, email: 'abc@example.org') # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      other_user = FactoryGirl.build(:user, email: 'abc@example.org')
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      db_users = User.where(email: other_user.email)
      expect(response.status).to eq(422)
      expect(db_users.length).to eq 1 # First user was not added to database
      expect(db_users[0].name).to eq user.name
    end

    it 'returns 422 if user is created without password' do
      user = FactoryGirl.build(:user, password: '') # Is not added to database yet
      params = { name: user.name, email: user.email, password: user.password }
      post "/users/", params: params.to_json, headers: json_header

      expect(response.status).to eq(422)
      expect(User.where(email: user.email)).to be_empty # User was not added to database
    end
  end
end

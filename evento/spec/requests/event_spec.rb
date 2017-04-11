require 'rails_helper'

RSpec.describe "Event API" do
  let(:user) { FactoryGirl.create(:user) }
  let(:category) { FactoryGirl.create(:category) }
  let(:event){ FactoryGirl.create(:event, creator_id: user.id, category_id: category.id) }

  context 'without authentication' do
    it 'returns 401 when put /event/1 is requested' do
      put '/events/1'
      expect(response.status).to eq(401)
    end

    it 'returns 401 when put /events/-1/ is requested' do
      put '/events/-1'
      expect(response.status).to eq(401)
    end

    it 'returns 401 when delete /events/1/ is requested'  do
      delete '/events/1'
      expect(response.status).to eq(401)
    end

    it 'returns 401 when delete /events/-1/ is requested' do
      delete '/events/-1'
      expect(response.status).to eq(401)
    end
  end

  context 'with authentication' do
    let(:header) { { Authorization: json["auth_token"], CONTENT_TYPE: "application/json" } }

    before(:each) do 
      post '/authenticate', params: { email: user.email, password: user.password }
      
      expect(response.status).to eq(200)  
      expect(json["auth_token"]).not_to eq(nil)
    end

    it 'returns 201 when get event is created with valid properties' do
      event = FactoryGirl.build(:event, creator_id: user.id) # Is not added to database yet
      params = { title: event.title, category_id: event.category_id }
      post "/events/", params: params.to_json, headers: header

      expect(response.status).to eq(201)
      expect(json["title"]).to eq event.title
      expect(json["creator"]["id"]).to eq user.id
      expect(json["category"]["id"]).to eq event.category_id
      expect(json).to have_key("id")
    end

    it 'saves newly created event to database' do
      event = FactoryGirl.build(:event, creator_id: user.id) # Is not added to database yet
      params = { title: event.title, category_id: event.category_id }
      post "/events/", params: params.to_json, headers: header

      db_event = Event.find(json['id']);
      expect(db_event.title).to eq event.title
      expect(db_event.id).to eq user.id
      expect(db_event.id).to eq event.category_id
    end

    it 'returns 422 if event is created without title' do
      event = FactoryGirl.build(:event, title: '') # Is not added to database yet
      params = { title: event.title, category_id: event.category_id }
      post "/events/", params: params.to_json, headers: header

      expect(response.status).to eq(422)
      expect(Event.where(creator_id: user.id)).to be_empty # Event was not added to database
    end

    it 'returns 422 if event is created without category' do
      event = FactoryGirl.build(:event, category_id: nil) # Is not added to database yet
      params = { title: event.title, category_id: event.category_id }
      post "/events/", params: params.to_json, headers: header

      expect(response.status).to eq(422)
      expect(Event.where(creator_id: user.id)).to be_empty # Event was not added to database
    end

    it 'does not allow request to override creator_id' do
      other_user = FactoryGirl.create(:user)

      event = FactoryGirl.build(:event, creator_id: other_user.id) # Is not added to database yet
      params = { title: event.title, category_id: event.category_id, creator_id: event.creator_id }
      post "/events/", params: params.to_json, headers: header

      expect(response.status).to eq(201)
      expect(Event.where(creator_id: other_user.id)).to be_empty # Other user is not the creator
      expect(Event.where(creator_id: user.id).length).to eq 1 # User is the creator
    end

    it 'updates event and returns 200 when put /events/#{event.id}/ is requested' do 
      put "/events/#{event.id}", params: { title: "NewTitle" }.to_json, headers: header

      event.reload  
      expect(response.status).to eq(200)
      expect(event.title).to eq("NewTitle")
    end

    it 'returns 404 when put /events/-1/ is requested' do 
      put "/events/-1", params: { title: "NewTitle" }.to_json, headers: header
      expect(response.status).to be(404)
    end

    it 'returns 422 when put /event/#{event.id} is requested with bad parameters' do
      too_short_title = "A"

      put "/events/#{event.id}", params: { title: too_short_title }.to_json, headers: header
      expect(response.status).to eq(422)   
    end

    it 'returns 401 when authenticated user tries to update other users event' do
      other_user = FactoryGirl.create(:user)
      other_users_event = FactoryGirl.create(:event, creator_id: other_user.id, category_id: category.id)
      put "/events/#{other_users_event.id}", params: { title: "NewTitle" }.to_json, headers: header

      expect(response.status).to eq(401)
    end

    it 'deletes event and returns 200 when delete /events/#{event.id}/ is requested' do
      delete "/events/#{event.id}", headers: header

      expect(Event.exists?(event.id)).to eq(false)   
      expect(response.status).to eq(200)
    end

    it 'returns 404 when delete /events/-1/ is requested' do
      put "/events/-1", params: { title: "NewTitle" }.to_json, headers: header
      expect(response.status).to be(404)
    end

    it 'returns 401 when authenticated user tries to delete other users event' do
      other_user = FactoryGirl.create(:user)
      other_users_event = FactoryGirl.create(:event, creator_id: other_user.id, category_id: category.id)
      delete "/events/#{other_users_event.id}", headers: header
 
      expect(response.status).to eq(401)
    end
  end

  context 'public requests' do
    it 'returns a list of events' do
      FactoryGirl.create_list(:event, 10)
      get '/events'

      # test for the 200 status-code
      expect(response).to be_success

      # check to make sure the right amount of events is returned
      expect(json.length).to eq(10)
    end

    it 'returns a single event' do
      get "/events/#{event.id}"

      # test for the 200 status-code
      expect(response).to be_success

      # check to make sure the right object is returned
      expect(json['id']).to eq(event.id)
      expect(json['title']).to eq(event.title)
      expect(json['creator']['id']).to eq(event.creator_id)
      expect(json['category']['id']).to eq(event.category_id)
    end

    it 'returns 404 when event is not found' do
      get "/events/-1"

      # test for the 404 status-code
      expect(response.status).to eq(404)
      expect(json['error']).to eq("Couldn't find Event with 'id'=-1")
    end

    it 'returns events attendees' do
      users =  FactoryGirl.create_list(:user, 10)
      event.attendees << users
      get "/events/#{event.id}/attendees"

      # test for the 200 status-code
      expect(response).to be_success

      # check to make sure the right amount of events is returned
      expect(json.length).to eq(10)

      # check that returned objects are correct
      expect(json[3]['id']).to eq(users[3].id)
      expect(json[3]['name']).to eq(users[3].name)
      expect(json[3]['email']).to eq(users[3].email)
    end

    it 'returns empty array if event does not have attendees' do
      get "/events/#{event.id}/attendees"

      # test for the 200 status-code
      expect(response).to be_success

      # check that returned objects are correct
      expect(json).to match_array([])
    end
  end
end
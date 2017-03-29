describe "User API" do
  let(:user) { FactoryGirl.create(:user) }

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

  it 'returns users events' do
    events =  FactoryGirl.create_list(:event, 10)
    user.events << events
    get "/users/#{user.id}/events"

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of events is returned
    expect(json.length).to eq(10)

    # check that returned objects are correct
    expect(json[3]['id']).to eq(events[3].id)
    expect(json[3]['title']).to eq(events[3].title)
    expect(json[3]['creator']['id']).to eq(events[3].creator_id)
    expect(json[3]['category']['id']).to eq(events[3].category_id)
  end

  it 'returns empty array if user does not have events' do
    get "/users/#{user.id}/events"

    # test for the 200 status-code
    expect(response).to be_success

    # check that returned objects are correct
    expect(json).to match_array([])
  end
end

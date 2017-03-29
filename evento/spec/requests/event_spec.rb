describe "Event API" do
  let(:event) { FactoryGirl.create(:event) }

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

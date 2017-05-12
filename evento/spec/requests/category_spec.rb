describe "Category API" do
  let(:category) { FactoryGirl.create(:category) }

  it 'returns a list of categories' do
    FactoryGirl.create_list(:category, 10)
    get '/categories'

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of categories is returned
    expect(json.length).to eq(10)
  end

  it 'returns a single category' do
    get "/categories/#{category.id}"

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right object is returned
    expect(json['id']).to eq(category.id)
    expect(json['name']).to eq(category.name)
    expect(json['parent_id']).to eq(category.parent_id)
  end

  it 'returns 404 when category is not found' do
    get "/categories/-1"

    # test for the 404 status-code
    expect(response.status).to eq(404)
    expect(json['error']).to eq("Couldn't find Category with 'id'=-1")
  end

  it "returns category's subcategories" do
    subcategories =  FactoryGirl.create_list(:category, 5, parent_id: category.id)

    get "/categories/#{category.id}/subcategories"

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of categories is returned
    expect(json.length).to eq(5)

    # check that returned objects are correct
    expect(json[3]['id']).to eq(subcategories[3].id)
    expect(json[3]['name']).to eq(subcategories[3].name)
    expect(json[3]['parent_id']).to eq(subcategories[3].parent_id)
  end

  it "returns empty array if category does not have subcategories" do
    get "/categories/#{category.id}/subcategories"

    # test for the 200 status-code
    expect(response).to be_success
    expect(json).to match_array([])
  end

  it "returns category's events" do
    events =  FactoryGirl.create_list(:event, 10, category_id: category.id)

    get "/categories/#{category.id}/events"

    # test for the 200 status-code
    expect(response).to be_success

    # check to make sure the right amount of categories is returned
    expect(json.length).to eq(10)

    # check that returned objects are correct
    expect(json[3]['id']).to eq(events[3].id)
    expect(json[3]['title']).to eq(events[3].title)
    expect(json[3]['creator']['id']).to eq(events[3].creator_id)
    expect(json[3]['category']['id']).to eq(category.id)
  end

  it "returns empty array if category does not have events" do
    get "/categories/#{category.id}/events"

    # test for the 200 status-code
    expect(response).to be_success
    expect(json).to match_array([])
  end
end

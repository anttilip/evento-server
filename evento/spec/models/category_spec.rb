require 'rails_helper'

RSpec.describe Category, type: :model do
  it "has a name" do
    category = Category.new name: "Sports"
    expect(category.name).to eq("Sports")
  end

  it "is saved with proper name" do
    category = Category.create name: "Sports"

    expect(category).to be_valid
    expect(Category.count).to eq(1) 
  end

  it "is not saved with too short name" do
    category = Category.create name: ""

    expect(category).not_to be_valid
    expect(Category.count).to eq(0) 
  end

  it "is not saved with too long name" do
    category = Category.create name: "this is way too long name for a category"

    expect(category).not_to be_valid
    expect(Category.count).to eq(0) 
  end

  it "get_subcategories returns subcategories" do
    sports = Category.create name: "Sports"
    badminton = Category.create name: "Badminton", parent_id: sports.id
    football = Category.create name: "Football", parent_id: sports.id

    expect(sports.get_subcategories).to match_array([badminton, football])
  end

  it "get_subcategories returns empty array when category does not have a subcategory" do
    sports = Category.create name: "Sports"
    expect(sports.get_subcategories).to match_array([])
  end

  it "get_events returns own events" do
    sports = Category.create name: "Sports"
    User.create name: "Antti", email: "antti@gmail.com" # Must be one user to create events

    juoksu = Event.create title: "Juoksun alkeet", category_id: sports.id, creator_id: 1
    bodaus = Event.create title: "Painonnosto", category_id: sports.id, creator_id: 1

    expect(sports.get_events).to match_array([juoksu, bodaus])
  end

  it "get_events returns also subcategory events" do
    sports = Category.create name: "Sports"
    badminton = Category.create name: "Badminton", parent_id: sports.id
    User.create name: "Antti", email: "antti@gmail.com" # Must be one user to create events

    juoksu = Event.create title: "Juoksun alkeet", category_id: sports.id, creator_id: 1
    bodaus = Event.create title: "Painonnosto", category_id: sports.id, creator_id: 1
    sulis = Event.create title: "Sulkapallokisat", category_id: badminton.id, creator_id: 1

    expect(sports.get_events).to match_array([juoksu, bodaus, sulis])
  end
end

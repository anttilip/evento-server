require 'rails_helper'

RSpec.describe Event, type: :model do
  it "has a title" do
    event = Event.new title: "Birthday party"
    expect(event.title).to eq("Birthday party")
  end

  it "is saved with proper title, category and creator" do
    sports = Category.create name: "Sports"
    matti = User.create name: "Matti", email: "matti@cs.helsinki.fi"
    bodypump = Event.create title: "Bodypump", category_id: sports.id, creator_id: matti.id

    expect(bodypump).to be_valid
    expect(Event.count).to eq(1)
  end

  it "is not saved without user existing" do
    sports = Category.create name: "Sports"
    bodypump = Event.create title: "Bodypump", category_id: sports.id, creator_id: 1

    expect(bodypump).not_to be_valid
    expect(Event.count).to eq(0)
  end

  it "is not saved without category existing" do
    matti = User.create name: "Matti", email: "matti@cs.helsinki.fi"
    bodypump = Event.create title: "Bodypump", category_id: 1, creator_id: matti.id

    expect(bodypump).not_to be_valid
    expect(Event.count).to eq(0)
  end

  it "is not saved with too short title" do
    sports = Category.create name: "Sports"
    matti = User.create name: "Matti", email: "matti@cs.helsinki.fi"
    bodypump = Event.create title: "", category_id: sports.id, creator_id: matti.id

    expect(bodypump).not_to be_valid
    expect(Event.count).to eq(0)
  end
end

require 'rails_helper'
require 'coveralls'
Coveralls.wear!

RSpec.describe Event, type: :model do
  it "has a title" do
    event = Event.new title: "Birthday party"
    expect(event.title).to eq("Birthday party")
  end
end

require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { FactoryGirl.create(:category) }

  it "is saved with proper name" do
    expect(category).to be_valid
    expect(category.save).to be_truthy
  end

  it "is not saved with too short name" do
    too_short = FactoryGirl.build(:category, name: '')

    expect(too_short).not_to be_valid
    expect(too_short.save).to be_falsey
  end

  it "is not saved with too long name" do
    too_long = FactoryGirl.build(:category, name: 'this is waaay too long name for a category')

    expect(too_long).not_to be_valid
    expect(too_long.save).to be_falsey
  end

  it "get_subcategories returns subcategories" do
    subcategories = FactoryGirl.create_list(:category, 15, parent_id: category.id)
    expect(category.get_subcategories).to match_array(subcategories)
  end

  it "get_subcategories returns empty array when category does not have a subcategory" do
    expect(category.get_subcategories).to match_array([])
  end

  it "get_events returns own events" do
    events = FactoryGirl.create_list(:event, 15, category_id: category.id)
    expect(category.get_events).to match_array(events)
  end

  it "get_events returns also subcategory events" do
    events = FactoryGirl.create_list(:event, 15, category_id: category.id)

    subcategories = FactoryGirl.create_list(:category, 15, parent_id: category.id)
    s_events = subcategories.map { |s| FactoryGirl.create(:event, category_id: s.id)}

    expect(category.get_events).to match_array(events + s_events)
  end
end

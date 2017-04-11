require 'rails_helper'

RSpec.describe Event, type: :model do
  let (:user) { FactoryGirl.create(:user) }
  let (:category) { FactoryGirl.create(:category) }
  let (:event) { FactoryGirl.build(:event, creator_id: user.id, category_id: category.id) }

  it "is saved with proper title, category and creator" do
    expect(event).to be_valid
    expect(event.save).to be_truthy
  end

  it "is not saved without user existing" do
    without_creator = FactoryGirl.build(:event, creator_id: -1)

    expect(without_creator).not_to be_valid
    expect(without_creator.save).to be_falsey
  end

  it "is not saved without category existing" do
    without_category = FactoryGirl.build(:event, category_id: -1)

    expect(without_category).not_to be_valid
    expect(without_category.save).to be_falsey
  end

  it "is not saved with too short title" do
    too_short_title = FactoryGirl.build(:event, title: '')

    expect(too_short_title).not_to be_valid
    expect(too_short_title.save).to be_falsey
  end
end

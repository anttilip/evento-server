require 'rails_helper'

RSpec.describe Event, type: :model do
  let (:user) { FactoryGirl.create(:user) }
  let (:category) { FactoryGirl.create(:category) }
  let (:event) { FactoryGirl.build(:event, creator_id: user.id, category_id: category.id) }

  it "is saved with proper title, time, category and creator" do
    expect(event).to be_valid
    expect(event.save).to be_truthy
  end

  it "is created with default image url if not specified" do
    expect(event).to be_valid
    expect(event.save).to be_truthy
    expect(event.image_url.present?).to be_truthy
  end

  it "is created with specific image url if specified" do
    url = "http://test.com/img.jpg"
    with_image_url = FactoryGirl.build(
      :event,
      creator_id: user.id,
      category_id: category.id,
      image_url: url
    )

    expect(with_image_url).to be_valid
    expect(event.save).to be_truthy
    expect(with_image_url.image_url).to eq(url)
  end

  it "is not saved with image url not ending with image extension" do
    url = "http://test.com/img.not_image_extension"
    with_invalid_image_url = FactoryGirl.build(
      :event,
      creator_id: user.id,
      category_id: category.id,
      image_url: url
    )

    expect(with_invalid_image_url).not_to be_valid
    expect(with_invalid_image_url.save).to be_falsey
  end

  it "is not saved with image url not ending with image extension" do
    url = "httsafp:/test.com!!--/img.not_image_extension"
    with_invalid_image_url = FactoryGirl.build(
      :event,
      creator_id: user.id,
      category_id: category.id,
      image_url: url
    )

    expect(with_invalid_image_url).not_to be_valid
    expect(with_invalid_image_url.save).to be_falsey
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

  it "is not saved with too long title" do
    too_long_title = FactoryGirl.build(:event, title: 'a' * 100)

    expect(too_long_title).not_to be_valid
    expect(too_long_title.save).to be_falsey
  end

  it "is not saved without title" do
    no_title = FactoryGirl.build(:event, title: nil)

    expect(no_title).not_to be_valid
    expect(no_title.save).to be_falsey
  end

  it "is not saved without time" do
    no_title = FactoryGirl.build(:event, time: nil)

    expect(no_title).not_to be_valid
    expect(no_title.save).to be_falsey
  end

  it "is not saved with time in the past" do
    invalid_time = FactoryGirl.build(:event, time: Time.now - 1.hour)

    expect(invalid_time).not_to be_valid
    expect(invalid_time.save).to be_falsey
  end
end

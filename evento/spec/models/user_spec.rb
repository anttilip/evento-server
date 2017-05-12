require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryGirl.build(:user) }

  it "is saved with proper name, email and password" do
    expect(user).to be_valid
    expect(user.save).to be_truthy
  end

  it "is not saved without email" do
    without_email = FactoryGirl.build(:user, email: nil)

    expect(without_email).not_to be_valid
    expect(without_email.save).to be_falsey
  end

  it "is not saved without password" do
    without_password = FactoryGirl.build(:user, password: nil)

    expect(without_password).not_to be_valid
    expect(without_password.save).to be_falsey
  end

  it "is not saved with empty password" do
    without_password = FactoryGirl.build(:user, password: '')

    expect(without_password).not_to be_valid
    expect(without_password.save).to be_falsey
  end

  it "is not saved without unique email" do
    with_same_email = FactoryGirl.build(:user, email: user.email)

    user.save # Original user must be in database
    expect(with_same_email).not_to be_valid
    expect(with_same_email.save).to be_falsey
  end
end

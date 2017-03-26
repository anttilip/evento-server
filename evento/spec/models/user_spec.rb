require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a name" do
    user = User.new name: "Pekka"
    expect(user.name).to eq("Pekka")
  end

  it "is saved with proper name and email" do
    user = User.create name: "Pekka", email: "pekka@cs.helsinki.fi"

    expect(user).to be_valid
    expect(User.count).to eq(1) 
  end

  it "is not saved without email" do
    user = User.create name: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0) 
  end
  
  it "is not saved without unique email" do
    User.create name: "Pekka", email: "paras@cs.helsinki.fi"
    user = User.create name: "Jussi", email: "paras@cs.helsinki.fi"

    expect(user).not_to be_valid
    expect(User.count).to eq(1) 
  end
end

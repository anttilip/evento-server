require 'rails_helper'

RSpec.describe User, type: :model do
  it "has a name" do
    user = User.new name: "Pekka"
    expect(user.name).to eq("Pekka")
  end
end

require 'rails_helper'

RSpec.describe Category, type: :model do
  it "has a name" do
    category = Category.new name: "Sports"
    expect(category.name).to eq("Sports")
  end
end

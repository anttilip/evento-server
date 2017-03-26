# This will guess the Category class
FactoryGirl.define do
  factory :category, aliases: [:supercategory] do
    name { Faker::Lorem.paragraph[0...15] }
  end
end

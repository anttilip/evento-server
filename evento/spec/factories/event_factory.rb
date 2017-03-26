# This will guess the Event class
FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.paragraph[0..30] }
    category
    user
  end
end

# This will guess the Event class
FactoryGirl.define do
  factory :event do
    title { Faker::Lorem.paragraph[3..30] }
    description { Faker::Lorem.paragraph[3..50] }
    time { Faker::Time.between(DateTime.now + 1, DateTime.now + 10) }
    category
    user
  end
end

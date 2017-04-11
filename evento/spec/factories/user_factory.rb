# This will guess the User class
FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
  end
end

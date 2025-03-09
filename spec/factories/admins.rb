FactoryBot.define do
  factory :admin do
    username { Faker::Internet.username }
    password { "password123" }
  end
end

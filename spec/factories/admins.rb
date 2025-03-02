FactoryBot.define do
  factory :admin do
    username { Faker::Internet.username }
    password { "password123" } # Use a fixed password for testing
  end
end

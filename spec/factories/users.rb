FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    pan_number { "#{Faker::Alphanumeric.alpha(number: 5).upcase}#{Faker::Number.number(digits: 4)}#{Faker::Alphanumeric.alpha(number: 1).upcase}" }
    adhaar_number { Faker::Number.number(digits: 12).to_s }
    status { "active" }
    balance { 10000 }
    account_number { Faker::Number.number(digits: 12).to_s }
    ifsc { "SBIN0001234" }
    pin { Faker::Number.number(digits: 4).to_s }
  end
end

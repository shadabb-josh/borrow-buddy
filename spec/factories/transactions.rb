FactoryBot.define do
  factory :transaction do
    association :user
    association :loan
    amount { 1000 }
    transaction_type { :deposit }  # Set a default valid type
  end
end

FactoryBot.define do
  factory :transaction do
    association :user
    association :loan
    amount { 1000 }
    transaction_type { :debit }
  end
end

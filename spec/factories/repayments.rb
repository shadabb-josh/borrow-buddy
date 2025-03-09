FactoryBot.define do
  factory :repayment do
    association :loan
    amount_paid { 1000.0 }
  end
end

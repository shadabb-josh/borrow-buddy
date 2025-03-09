FactoryBot.define do
  factory :loan do
    association :borrower, factory: :user
    association :lender, factory: :user
    amount { 10000 }
    interest { 12.5 }
    purpose { "Personal Loan" }
    status { "pending" } # Change based on your app's status enum or validation
    repayment_till { 30.days.from_now }
    expected_return { amount + (amount * (interest / 100.0)) } # Basic calculation

    trait :approved do
      status { "approved" }
    end

    trait :rejected do
      status { "rejected" }
    end
  end
end

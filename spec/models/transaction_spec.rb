require 'rails_helper'

RSpec.describe Transaction, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:loan) }
  end

  describe "Validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:loan_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:transaction_type) }
  end

  describe "Enums" do
    it "should have correct transaction types" do
      expect(Transaction.transaction_types).to eq({
        "deposit" => 0,
        "withdrawal" => 1,
        "investment" => 2,
        "repayment" => 3
      })
    end
  end
end

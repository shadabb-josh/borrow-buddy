require 'rails_helper'

RSpec.describe TransactionByUsers, type: :service do
  let(:user) { create(:user) }
  let!(:transactions) { create_list(:transaction, 0, user: user) }
  let!(:other_transactions) { create_list(:transaction, 1) }

  it 'returns transactions belonging to the given user' do
    result = TransactionByUsers.new(user).call
    expect(result).to match_array(transactions)
  end

  it 'does not return transactions from other users' do
    result = TransactionByUsers.new(user).call
    expect(result).not_to include(*other_transactions)
  end
end

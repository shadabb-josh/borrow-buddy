require 'rails_helper'

RSpec.describe Repayment, type: :model do
  describe 'associations' do
    it { should belong_to(:loan) }
  end

  describe 'validations' do
    it { should validate_presence_of(:loan_id) }
    it { should validate_presence_of(:amount_paid) }
  end
end

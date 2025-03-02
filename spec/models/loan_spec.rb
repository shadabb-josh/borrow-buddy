require 'rails_helper'

RSpec.describe Loan, type: :model do
  let(:loan) { create(:loan) }

  describe "Associations" do
    it { should belong_to(:borrower).class_name('User') }
    it { should belong_to(:lender).class_name('User') }
  end


  describe "Validations" do
    it { should validate_presence_of(:borrower_id) }
    it { should validate_presence_of(:lender_id) }
    it { should validate_presence_of(:amount) }
    it { should validate_presence_of(:interest) }
    it { should validate_presence_of(:purpose) }
    it { should validate_presence_of(:repayment_till) }
    it { should validate_presence_of(:status) }
  end

  describe "Enums" do
    it { should define_enum_for(:status).with_values(pending: 0, approved: 1, funded: 2, repaid: 3) }
  end
end

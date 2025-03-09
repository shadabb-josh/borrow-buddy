require 'rails_helper'

RSpec.describe Admin, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:username) }
  end

  # describe "Secure Password" do
  #   let(:admin) { create(:admin) }

  #   it "authenticates with the correct password" do
  #     expect(admin.authenticate("securepassword123")).to be_truthy
  #   end

  #   it "fails authentication with the wrong password" do
  #     expect(admin.authenticate("wrongpassword")).to be_falsey
  #   end
  # end
end

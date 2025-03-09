require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "Validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:account_number) }
    it { should validate_presence_of(:ifsc) }
    it { should validate_presence_of(:pin) }
    it { should validate_presence_of(:balance) }

    it { should validate_length_of(:pin).is_equal_to(4) }

    it { should validate_uniqueness_of(:email) }
    it { should validate_uniqueness_of(:account_number) }
    it { should validate_uniqueness_of(:pan_number).allow_nil }
    it { should validate_uniqueness_of(:adhaar_number).allow_nil }

    it { should allow_value("ABCDE1234F").for(:pan_number) }
    it { should_not allow_value("12345ABCD").for(:pan_number) }

    it { should allow_value("123456789012").for(:adhaar_number) }
    it { should_not allow_value("12345").for(:adhaar_number) }

    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }

    it { should validate_inclusion_of(:status).in_array([ "active", "deactive" ]) }
  end
end

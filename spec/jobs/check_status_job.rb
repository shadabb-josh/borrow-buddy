require "rails_helper"
require "sidekiq/testing"

RSpec.describe CheckStatusJob, type: :job do
  before { Sidekiq::Testing.inline! }

  let!(:loan_approved_old) { create(:loan, status: :approved, updated_at: 3.hours.ago) }
  let!(:loan_approved_recent) { create(:loan, status: :approved, updated_at: 1.hour.ago) }
  let!(:loan_funded) { create(:loan, status: :funded, updated_at: 3.hours.ago) }
  let!(:loan_pending) { create(:loan, status: :pending, updated_at: 3.hours.ago) }

  it "changes status of old approved loans back to pending" do
    expect { CheckStatusJob.new.perform }.to change { loan_approved_old.reload.status }.from("approved").to("pending")
  end

  it "does not change status of recently approved loans" do
    expect { CheckStatusJob.new.perform }.not_to change { loan_approved_recent.reload.status }
  end

  it "does not change status of funded or already pending loans" do
    expect { CheckStatusJob.new.perform }.not_to change { loan_funded.reload.status }
    expect { CheckStatusJob.new.perform }.not_to change { loan_pending.reload.status }
  end
end

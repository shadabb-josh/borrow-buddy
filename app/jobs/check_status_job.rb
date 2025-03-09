class CheckStatusJob
  include Sidekiq::Job

  # If status is "approved" and loan is not "funded" in the given time
  # this Job will execute in every 15 minutes and change status back
  # "pending"

  def perform
    loans = Loan.where(status: 1).where("updated_at <= ?", 2.hours.ago)
    loans.update_all(status: 0, updated_at: Time.current)
  end
end

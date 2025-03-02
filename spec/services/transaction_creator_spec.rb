require 'rails_helper'

RSpec.describe TransactionCreator, type: :service do
  let(:sender) { create(:user, balance: 1000, status: "active", pin: "1234") }
  let(:receiver) { create(:user, balance: 500, status: "active") }
  let(:loan) { create(:loan) }

  let(:valid_params) do
    {
      sender_id: sender.id,
      receiver_id: receiver.id,
      amount: 200,
      loan_id: loan.id,
      entered_pin: "1234"
    }
  end

  describe "#call" do
    context "with valid transaction" do
      it "creates a transaction and updates balances" do
        expect {
          TransactionCreator.new(valid_params).call
        }.to change { Transaction.count }.by(2)
          .and change { sender.reload.balance }.by(-200)
          .and change { receiver.reload.balance }.by(200)
      end

      it "sends success emails" do
        allow(UserMailer).to receive(:transaction_success_for_sender).and_return(double(deliver_later: true))
        allow(UserMailer).to receive(:transaction_success_for_reciever).and_return(double(deliver_later: true))

        TransactionCreator.new(valid_params).call

        expect(UserMailer).to have_received(:transaction_success_for_sender).with(sender, 200, receiver)
        expect(UserMailer).to have_received(:transaction_success_for_reciever).with(receiver, 200, sender)
      end
    end

    context "when sender and receiver are the same" do
      it "raises an error" do
        invalid_params = valid_params.merge(receiver_id: sender.id)
        expect {
          TransactionCreator.new(invalid_params).call
        }.to raise_error(StandardError, I18n.t("bank.sender_reciever_id_equal"))
      end
    end

    context "when sender has insufficient balance" do
      it "raises an error" do
        invalid_params = valid_params.merge(amount: 2000)
        expect {
          TransactionCreator.new(invalid_params).call
        }.to raise_error(StandardError, I18n.t("bank.insufficient_balance"))
      end
    end

    # context "when account is not active" do
    #   it "raises an error" do
    #     sender.update(status: "inactive")
    #     expect {
    #       TransactionCreator.new(valid_params).call
    #     }.to raise_error(StandardError, I18n.t("bank.account_not_active"))
    #   end
    # end

    context "when PIN is incorrect" do
      it "raises an error" do
        invalid_params = valid_params.merge(entered_pin: "9999")
        expect {
          TransactionCreator.new(invalid_params).call
        }.to raise_error(StandardError, I18n.t("bank.invalid_pin"))
      end
    end

    context "when transaction fails" do
      it "sends a failure email" do
        allow(UserMailer).to receive(:transaction_failure_for_sender).and_return(double(deliver_later: true))

        invalid_params = valid_params.merge(amount: 2000) # Insufficient balance
        expect {
          TransactionCreator.new(invalid_params).call
        }.to raise_error(StandardError)

        expect(UserMailer).to have_received(:transaction_failure_for_sender).with(sender, 2000, receiver, I18n.t("bank.insufficient_balance"))
      end
    end
  end
end

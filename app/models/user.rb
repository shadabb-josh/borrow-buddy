class User < ApplicationRecord
  has_secure_password

  EMAIL_REGEXP = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/
  PAN_REGEXP = /\A[A-Z]{5}[0-9]{4}[A-Z]{1}\z/
  ADHAAR_REGEXP = /\A\d{12}\z/

  with_options unless: :skip_validations? do
    validates :first_name, :last_name, :email, presence: true
    validates :pan_number, format: { with: PAN_REGEXP, message: I18n.t("user.must_be_a_valid_pan") },
               uniqueness: true, allow_nil: true
    validates :adhaar_number, format: { with: ADHAAR_REGEXP, message: I18n.t("user.must_be_a_valid_adhaar") },
               uniqueness: true, allow_nil: true
    validates :status, inclusion: { in: [ "active", "deactive" ] }
  end

  validates :email, format: { with: EMAIL_REGEXP, message: "must be a valid email" }, uniqueness: true

  attr_accessor :skip_validations

  def skip_validations?
    skip_validations == true
  end

  def generate_otp
    otp = rand(100000...999999).to_s
    Rails.cache.write("user_#{id}_otp", otp, expires_in: 10.minutes)
    Rails.cache.write("user_#{id}_otp_sent_at", Time.current, expires_in: 10.minutes)
    Rails.cache.write("user_#{id}_otp_attempts", 0, expires_in: 10.minutes)
    otp
  end

  def otp_valid?(entered_otp)
    stored_otp = Rails.cache.read("user_#{id}_otp")
    otp_sent_at = Rails.cache.read("user_#{id}_otp_sent_at")
    attempts = Rails.cache.read("user_#{id}_otp_attempts") || 0

    return false if stored_otp.nil? || otp_sent_at.nil?

    if attempts >= 3
      clear_otp
      return false
    end

    if stored_otp.to_s == entered_otp.to_s && otp_sent_at >= 10.minutes.ago
      true
    else
      Rails.cache.write("user_#{id}_otp_attempts", attempts + 1, expires_in: 10.minutes)
      false
    end
  end

  def clear_otp
    Rails.cache.delete("user_#{id}_otp")
    Rails.cache.delete("user_#{id}_otp_sent_at")
    Rails.cache.delete("user_#{id}_otp_attempts")
  end
end

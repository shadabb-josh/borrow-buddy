class User < ApplicationRecord
  has_secure_password

  # REGEX-CONSTANTS
  EMAIL_REGEXP = /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\z/
  PAN_REGEXP = /\A[A-Z]{5}[0-9]{4}[A-Z]{1}\z/
  ADHAAR_REGEXP = /\A\d{12}\z/

  # Validations
  validates :first_name, :last_name, :email, presence: true
  validates :email, format: { with: EMAIL_REGEXP, message: "must be a valid email" }, uniqueness: true
  validates :pan_number, format: { with: PAN_REGEXP, message: "must be a valid PAN number" }, uniqueness: true, allow_nil: true
  validates :adhaar_number, format: { with: ADHAAR_REGEXP, message: "must be a valid Adhaar number" }, uniqueness: true, allow_nil: true
  validates :status, inclusion: { in: [ "active", "deactive" ] }
end

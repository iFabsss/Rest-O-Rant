class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates_uniqueness_of :email_address, case_sensitive: false
  validates_format_of :email_address, with: URI::MailTo::EMAIL_REGEXP
  validates_presence_of :email_address, :password, on: :create

  def is_admin?
    self.is_admin
  end
end

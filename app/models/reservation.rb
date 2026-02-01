class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :timeslot_x_table

  delegate :timeslot, to: :timeslot_x_table
  delegate :table, to: :timeslot_x_table

  validates :people_num, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :contact_name, presence: true
  validates :contact_number, presence: true
  validates :contact_email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end

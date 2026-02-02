class Timeslot < ApplicationRecord
  has_many :timeslot_x_tables, dependent: :destroy
  has_many :tables, through: :timeslot_x_tables

  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :max_no_tables, presence: true, numericality: { only_integer: true, greater_than: 0 }

  private

  def end_after_start
    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end

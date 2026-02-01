class TimeslotXTable < ApplicationRecord
  belongs_to :timeslot
  belongs_to :table

  STATUSES = %w[available reserved].freeze

  has_one :reservation

  validates :status, presence: true, inclusion: { in: STATUSES }
end

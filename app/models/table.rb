class Table < ApplicationRecord
  has_many :timeslot_x_tables, dependent: :destroy
  has_many :timeslots, through: :timeslot_x_tables

  validates :table_no, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: true
  validates :max_people, presence: true, numericality: { only_integer: true, greater_than: 0 }
end

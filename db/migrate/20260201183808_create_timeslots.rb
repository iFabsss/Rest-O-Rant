class CreateTimeslots < ActiveRecord::Migration[8.1]
  def change
    create_table :timeslots, id: :uuid do |t|
      t.date :date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :max_no_tables, null: false

      t.timestamps
    end
  end
end

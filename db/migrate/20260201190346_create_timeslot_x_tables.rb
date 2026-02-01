class CreateTimeslotXTables < ActiveRecord::Migration[8.1]
  def change
    create_table :timeslot_x_tables do |t|
      t.references :timeslot, null: false, foreign_key: true, type: :uuid
      t.references :table, null: false, foreign_key: true
      t.string :status, null: false, default: 'available'

      t.timestamps
    end

    add_index :timeslot_x_tables, [ :timeslot_id, :table_id ], unique: true
  end
end

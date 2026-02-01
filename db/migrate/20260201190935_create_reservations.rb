class CreateReservations < ActiveRecord::Migration[8.1]
  def change
    create_table :reservations, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :timeslot_x_table, null: false, foreign_key: true
      t.integer :people_num, null: false
      t.string :contact_name, null: false
      t.string :contact_number, null: false
      t.string :contact_email, null: false

      t.timestamps
    end
  end
end

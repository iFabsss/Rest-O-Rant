class CreateTables < ActiveRecord::Migration[8.1]
  def change
    create_table :tables do |t|
      t.integer :table_no, null: false
      t.integer :max_people, null: false

      t.timestamps
    end
  end
end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# db/seeds.rb

require "time"

# --- Clear old data ---
puts "Cleaning database..."
Reservation.destroy_all
TimeslotXTable.destroy_all
Timeslot.destroy_all
Table.destroy_all
User.destroy_all

puts "Database cleaned."

# --- Create example users ---
puts "Creating users..."
admin = User.create!(
  email_address: "admin@example.com",
  password: "password",
  password_confirmation: "password",
  is_admin: true
)

user = User.create!(
  email_address: "user@example.com",
  password: "password",
  password_confirmation: "password",
  is_admin: false
)

puts "Created users: admin and normal user."

# --- Create tables ---
puts "Creating restaurant tables..."
tables = []
5.times do |i|
  tables << Table.create!(
    table_no: i + 1,
    max_people: 4
  )
end
puts "Created 5 tables."

puts "Creating timeslots for 7 days..."
timeslots = []

start_date = Date.today
end_date = start_date + 6 

slot_times = [ "18:00", "19:00", "20:00" ]

(start_date..end_date).each do |date|
  slot_times.each do |start_time|
    start_time_obj = Time.parse(start_time)
    end_time_obj = start_time_obj + 1.hour

    timeslots << Timeslot.create!(
      date: date,
      start_time: start_time_obj.strftime("%H:%M"),
      end_time: end_time_obj.strftime("%H:%M"),
      max_no_tables: tables.count
    )
  end
end

puts "Created #{timeslots.count} timeslots for 7 days."

puts "Creating Timeslot_X_Tables..."
timeslot_x_tables = []

timeslots.each do |slot|
  tables.each do |table|
    timeslot_x_tables << TimeslotXTable.create!(
      timeslot: slot,
      table: table,
      status: "available"
    )
  end
end

puts "Created #{timeslot_x_tables.count} Timeslot_X_Tables."

puts "Creating a sample reservation..."
sample_slot_table = timeslot_x_tables.first
Reservation.create!(
  user: user,
  timeslot_x_table: sample_slot_table,
  people_num: 2,
  contact_name: user.email_address,
  contact_number: "09171234567",
  contact_email: user.email_address
)
sample_slot_table.update!(status: "reserved")

puts "Sample reservation created for first available table."
puts "✅ Seeding complete!"

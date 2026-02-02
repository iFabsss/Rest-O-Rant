class TimeslotsController < ApplicationController
  def index
    date = params[:date]

    return render json: { error: "Date is required" }, status: :bad_request if date.blank?

    timeslots = Timeslot
      .where(date: date)
      .includes(timeslot_x_tables: :table)
      .order(:start_time)

    render json: timeslots.map { |timeslot|
      {
        id: timeslot.id,
        start_time: timeslot.start_time.strftime("%H:%M"),
        end_time: timeslot.end_time.strftime("%H:%M"),
        max_no_tables: timeslot.max_no_tables,
        tables: timeslot.timeslot_x_tables.map { |txt|
          {
            timeslot_x_table_id: txt.id,
            table_no: txt.table.table_no,
            max_people: txt.table.max_people,
            status: txt.status
          }
        }
      }
    }
  end
end

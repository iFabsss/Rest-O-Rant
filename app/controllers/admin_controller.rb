class AdminController < ApplicationController
  before_action :require_admin
  def index
  end

  def reservations
    @reservations = Reservation.includes(:user, timeslot_x_table: :timeslot).order("timeslots.date DESC, timeslots.start_time DESC").references(:timeslots)
  end

  def show_reservation
      reservation = Reservation.find(params[:id])
      timeslot = reservation.timeslot_x_table.timeslot
      table = reservation.timeslot_x_table.table

      render json: {
        date: timeslot.date.strftime("%B %d, %Y"),
        start_time: timeslot.start_time.strftime("%I:%M %p"),
        end_time: timeslot.end_time.strftime("%I:%M %p"),
        table_no: table.table_no,
        max_people: table.max_people,
        people_num: reservation.people_num,
        contact_name: reservation.contact_name,
        contact_email: reservation.contact_email,
        contact_number: reservation.contact_number
      }
  end

  def update_reservation
    reservation = Reservation.find(params[:id])

    if reservation.update(reservation_params)
      redirect_to admin_reservations_path, notice: "Reservation updated successfully."
    else
      redirect_to admin_reservations_path, alert: "Failed to update reservation."
    end
  end

  def cancel_reservation
    reservation = Reservation.find(params[:id])
    reservation.destroy
    redirect_to admin_reservations_path, notice: "Reservation cancelled successfully."
  end

  def timeslots
    @timeslots = Timeslot.order(date: :asc, start_time: :asc)
  end

  def create_timeslot
    timeslot = Timeslot.new(timeslot_params)

    if timeslot.save
      render json: { success: true }
    else
      render json: { success: false, errors: timeslot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_timeslot
    timeslot = Timeslot.find(params[:id])

    if timeslot.update(timeslot_params)
      render json: { success: true }
    else
      render json: { success: false, errors: timeslot.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_timeslot
    timeslot = Timeslot.find(params[:id])
    timeslot.destroy
    render json: { success: true }
  end

  def show_timeslot
    timeslot = Timeslot.find(params[:id])

    linked_table_ids = timeslot.timeslot_x_tables.pluck(:table_id)

    render json: {
      id: timeslot.id,
      date: timeslot.date,
      start_time: timeslot.start_time.strftime("%H:%M"),
      end_time: timeslot.end_time.strftime("%H:%M"),
      tables: timeslot.timeslot_x_tables.includes(:table).map {
        |tx|
        {
          id: tx.table.id,
          table_no: tx.table.table_no,
          max_people: tx.table.max_people
        }
      },
      available_tables: Table
        .where.not(id: linked_table_ids)
        .map { |t|
          { id: t.id, table_no: t.table_no, max_people: t.max_people }
        }
    }
  end


  def add_table_to_timeslot
    timeslot = Timeslot.find(params[:id])
    table = Table.find(params[:table_id])

    # prevent duplicates
    existing = TimeslotXTable.find_by(timeslot: timeslot, table: table)
    if existing
      render json: { success: false, message: "Table already added" }, status: :unprocessable_entity
      return
    end

    TimeslotXTable.create!(
      timeslot: timeslot,
      table: table,
      status: "available"
    )

    render json: { success: true }
  end

  def remove_table_from_timeslot
    tx = TimeslotXTable.find_by(
      timeslot_id: params[:id],
      table_id: params[:table_id]
    )

    if tx
      tx.destroy
      render json: { success: true }
    else
      render json: { success: false }, status: :not_found
    end
  end


  def tables
  end



  private
  def require_admin
    unless current_user&.is_admin?
      render plain: "Forbidden", status: :forbidden
    end
  end

  def reservation_params
    params.permit(:people_num, :contact_name, :contact_number, :contact_email)
  end

  def timeslot_params
    params.require(:timeslot).permit(:date, :start_time, :end_time, :max_no_tables)
  end
end

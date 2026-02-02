class HomeController < ApplicationController
  def index
    @tables = Table.all
  end

  def reserve
    @timeslot_x_table_id = params[:timeslot_x_table_id]

    @timeslot_x_table = TimeslotXTable.find_by(id: @timeslot_x_table_id)
    @timeslot = @timeslot_x_table.timeslot
    @table = @timeslot_x_table.table
    @table_no = @table.table_no
    @max_people = @table.max_people
    @date = @timeslot.date
    @start_time = @timeslot.start_time
    @end_time = @timeslot.end_time
  end

  def confirm
    @reservation = Reservation.new(reservation_params.merge(user_id: current_user.id))

    # Find the timeslot & table info again (needed for render :reserve)
    @timeslot_x_table = TimeslotXTable.find_by(id: @reservation.timeslot_x_table_id)
    @timeslot = @timeslot_x_table.timeslot
    @table = @timeslot_x_table.table
    @table_no = @table.table_no
    @max_people = @table.max_people
    @date = @timeslot.date
    @start_time = @timeslot.start_time
    @end_time = @timeslot.end_time

    # Edge case: check people number
    if @reservation.people_num != @max_people
      flash.now[:alert] = "Must occupy exactly the max number of people!"
      render :reserve, status: :unprocessable_entity and return
    end

    # Edge case: cannot reserve past timeslot
    if @reservation.timeslot_x_table.timeslot.date < Date.current ||
      (@reservation.timeslot_x_table.timeslot.date == Date.current &&
        @reservation.timeslot_x_table.timeslot.start_time < Time.current)
      flash.now[:alert] = "Cannot make reservation for past timeslot!"
      render :reserve, status: :unprocessable_entity and return
    end

    # Edge case: at least 2 hours in advance
    if @reservation.timeslot_x_table.timeslot.date == Date.current &&
      (@reservation.timeslot_x_table.timeslot.start_time - Time.current) < 2.hours
      flash.now[:alert] = "Reservations must be made at least 2 hours in advance!"
      render :reserve, status: :unprocessable_entity and return
    end

    # Save reservation
    if @reservation.save
      @timeslot_x_table.update(status: "reserved")
      redirect_to home_reservations_path, notice: "Reservation confirmed"
    else
      flash.now[:alert] = @reservation.errors.full_messages.join(", ")
      render :reserve, status: :unprocessable_entity
    end
  end


  def reservations
    @reservations = current_user.reservations.joins(timeslot_x_table: :timeslot).order("timeslots.date ASC, timeslots.start_time ASC")
  end

  def cancel_reservation
    @reservation = current_user.reservations.find_by(id: params[:id])
    if @reservation
      @reservation.destroy
      redirect_to home_reservations_path, notice: "Reservation cancelled"
    else
      redirect_to home_reservations_path, alert: "Reservation not found"
    end
  end

  def reservation_params
    params.permit(:timeslot_x_table_id, :people_num, :contact_name, :contact_number, :contact_email)
  end
end

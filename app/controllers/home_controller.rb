class HomeController < ApplicationController
  def index
  end

  def reserve
    # Get the timeslot_x_table_id from params to pre-fill the form
    @timeslot_x_table_id = params[:timeslot_x_table_id]

    # You can also load the TimeslotXTable object for display
    @timeslot_x_table = TimeslotXTable.find_by(id: @timeslot_x_table_id)
  end

  def confirm
  end

  def reservations
  end

  def require_admin
    unless current_user&.is_admin?
      render plain: "Forbidden", status: :forbidden
    end
  end
end

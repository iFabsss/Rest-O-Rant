class HomeController < ApplicationController
  def index
  end

  def reserve
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

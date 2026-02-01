class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

  def new
    render layout: false
  end

  def create
    @user = User.authenticate_by(params.permit(:email_address, :password))
    if @user
      start_new_session_for user
      redirect_to after_authentication_url
    else
      errors = []

      email = params[:email_address].to_s.strip.downcase
      if email.blank?
        errors << "Email address is required"
      elsif !User.exists?(email_address: email)
        errors << "No account found with that email address"
      else
        errors << "Incorrect password"
      end

      flash[:login_errors] = errors.join(". ")
      redirect_to root_path
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_path, status: :see_other
  end
end

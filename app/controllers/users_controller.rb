class UsersController < ApplicationController
  allow_unauthenticated only: [ :new, :create ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      # Show errors inside modal
      flash[:signup_errors] = @user.errors.full_messages
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end

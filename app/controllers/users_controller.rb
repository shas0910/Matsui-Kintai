class UsersController < ApplicationController

  def edit
  end

  def update
    current_user.update(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :department, :user_type, :hire_date, :approver_id)
  end

end

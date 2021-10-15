class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
    @approvers = User.where(user_type: "上長")
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to users_path
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:email, :last_name,  :first_name, :department, :user_type, :hire_date, :approver_id)
  end

end

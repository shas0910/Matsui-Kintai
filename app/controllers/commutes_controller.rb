class CommutesController < ApplicationController

  def new
    
  end

  def create
    if params[:commute][:car_type].present?
      if params[:commute][:car_route].blank? || params[:commute][:car_distance].blank?
        redirect_to new_commute_path, alert: "入力に不備があります"
        return
      end
    end
    if params[:commute][:car_route].present?
      if params[:commute][:car_type].blank? || params[:commute][:car_distance].blank?
        redirect_to new_commute_path, alert: "入力に不備があります"
        return
      end
    end
    if params[:commute][:car_distance].present?
      if params[:commute][:car_type].blank? || params[:commute][:car_route].blank?
        redirect_to new_commute_path, alert: "入力に不備があります"
        return
      end
    end
    if params[:commute][:pass_route].present?
      if params[:commute][:pass_fee].blank?
        redirect_to new_commute_path, alert: "入力に不備があります"
        return
      end
    end
    if params[:commute][:pass_fee].present?
      if params[:commute][:pass_route].blank?
        redirect_to new_commute_path, alert: "入力に不備があります"
        return
      end
    end
    
    commute = Commute.find_or_initialize_by(user_id: current_user.id)
    if commute.new_record?
      commute = Commute.new(commute_params)
      commute.save
    else
      commute.update(commute_params)
    end
    redirect_to setting_path, notice: "通勤経路設定を保存しました"
  end

  def edit
    @commute = Commute.find(params[:id])
  end

  def update
    commute = Commute.find(params[:id])
    commute.update(commute_edit_params)
    redirect_to setting_path, notice: "通勤経路設定を保存しました"
  end

  private

  def commute_params
    params.require(:commute).permit(:car_type, :car_route, :car_distance, :pass_route, :pass_fee).merge(user_id: current_user.id)
  end

  def commute_edit_params
    params.require(:commute).permit(:car_type, :car_route, :car_distance, :pass_route, :pass_fee)
  end

end

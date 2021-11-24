class TravelCostsController < ApplicationController

  def create_car
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    light = current_user.commute.car_distance.to_f / 20 * 135
    regular = current_user.commute.car_distance.to_f / 15 * 135
    motorbike = current_user.commute.car_distance.to_f / 30 * 135
    if travel_cost.new_record?
      travel_cost.commute_type = current_user.commute.car_type
      if current_user.commute.car_type == "軽自動車"
        travel_cost.travel_cost = light.round
      elsif current_user.commute.car_type == "普通車"
        travel_cost.travel_cost = regular.round
      elsif current_user.commute.car_type == "バイク"
        travel_cost.travel_cost = motorbike.round
      end
      travel_cost.remark = current_user.commute.car_route
      travel_cost.save
    else
      if current_user.commute.car_type == "軽自動車"
        travel_cost.update(commute_type: current_user.commute.car_type, travel_cost: light.round, remark: current_user.commute.car_route)
      elsif current_user.commute.car_type == "普通車"
        travel_cost.update(commute_type: current_user.commute.car_type, travel_cost: regular.round, remark: current_user.commute.car_route)
      elsif current_user.commute.car_type == "バイク"
        travel_cost.update(commute_type: current_user.commute.car_type, travel_cost: motorbike.round, remark: current_user.commute.car_route)
      end
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：#{current_user.commute.car_type}"
  end

  def create_train
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost.commute_type = "電車・バス（往復）"
      travel_cost.travel_cost = current_user.commute.train_fee
      travel_cost.remark = current_user.commute.train_route
      travel_cost.save
    else
      travel_cost.update(commute_type: "電車・バス（往復）", travel_cost: current_user.commute.train_fee, remark: current_user.commute.train_route)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：電車・バス（往復）"
  end

  def create_pass
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost.commute_type = "電車・バス（定期使用）"
      travel_cost.travel_cost = 0
      travel_cost.remark = current_user.commute.pass_route
      travel_cost.save
    else
      travel_cost.update(commute_type: "電車・バス（定期使用）", travel_cost: 0, remark: current_user.commute.pass_route)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：電車・バス（定期使用）"
  end

  def create_walk
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost.commute_type = "徒歩"
      travel_cost.travel_cost = 0
      travel_cost.save
    else
      travel_cost.update(commute_type: "徒歩", travel_cost: 0, remark: nil)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：徒歩"
  end

  def create_trip
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost.commute_type = "出張"
      travel_cost.travel_cost = 0
      travel_cost.save
    else
      travel_cost.update(commute_type: "出張", travel_cost: 0, remark: nil)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：出張"
  end

  def create_remote
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost.commute_type = "リモートワーク"
      travel_cost.travel_cost = 0
      travel_cost.save
    else
      travel_cost.update(commute_type: "リモートワーク", travel_cost: 0, remark: nil)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：リモートワーク"
  end

  def create_other
    travel_cost = TravelCost.find_or_initialize_by(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
    if travel_cost.new_record?
      travel_cost = TravelCost.new(travel_cost_params)
      travel_cost.save
    else
      travel_cost.update(travel_cost_params)
    end
    redirect_to new_timecard_path, notice: "本日の通勤設定をしました：その他"
  end

  private

  def travel_cost_params
    params.require(:travel_cost).permit(:commute_type, :travel_cost, :remark).merge(user_id: current_user.id, day_id: Day.find_by(date: Date.today).id)
  end

end

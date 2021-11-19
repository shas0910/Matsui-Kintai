class Commute < ApplicationRecord

  belongs_to :user

  validates :car_type, presence: true, if: "car_route.present?"
  validates :car_type, presence: true, if: "car_distance.present?"

  validates :car_route, presence: true, if: "car_type.present?"
  validates :car_route, presence: true, if: "car_distance.present?"

  validates :car_distance, presence: true, if: "car_type.present?"
  validates :car_distance, presence: true, if: "car_route.present?"

  validetes :pass_route, presence: true, if: "pass_fee.present?"

  validetes :pass_fee, presence: true, if: "psss_route.present?"
end

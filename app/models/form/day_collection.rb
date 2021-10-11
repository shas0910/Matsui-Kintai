class Form::DayCollection < Form::Base
  FORM_COUNT = 31
  attr_accessor :days

  def initialize(attributes = {})
    super attributes
    self.days = FORM_COUNT.times.map { Day.new() } unless self.days.present?
  end

  def days_attributes=(attributes)
    self.days = attributes.map { |_, v| Day.new(v) }
  end

  def save
    Day.transaction do
      self.days.map do |product|
        if day.availability
          day.save
        end
      end
    end
      return true
    rescue => e
      return false
  end
end
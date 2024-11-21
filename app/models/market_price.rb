class MarketPrice < ApplicationRecord
  scope :by_date, ->(date) { where(time: date.at_beginning_of_day..date.at_end_of_day) }

  validates :time, presence: true, uniqueness: true
  validates :value, presence: true
end

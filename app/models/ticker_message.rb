class TickerMessage < ApplicationRecord
  validates :message, presence: true, uniqueness: true
end

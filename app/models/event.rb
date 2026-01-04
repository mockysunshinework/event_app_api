class Event < ApplicationRecord
    has_many :event_applications, dependent: :destroy
  has_many :users, through: :event_applications
end

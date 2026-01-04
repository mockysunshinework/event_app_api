class User < ApplicationRecord
  has_many :event_applications, dependent: :destroy
  has_many :events, through: :event_applications
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :event_applications, dependent: :destroy
  has_many :events, through: :event_applications
end

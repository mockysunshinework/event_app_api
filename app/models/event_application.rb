class EventApplication < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { pending: 0, confirmed: 1, canceled: 2 }

  def cancel!
    raise AlreadyCanceledError if canceled?

    update!(
      status: :canceled,
      canceled_at: Time.current
    )
  end

  def self.apply_for!(user:, event:)
    canceled_application = self.find_by(user: user, event: event, status: :canceled)

    if canceled_application.present?
      canceled_application.reapply!
      canceled_application
    else
      self.create!(
        user: user,
        event: event,
        status: :pending,
        applied_at: Time.zone.now,
      )
    end
  end

  def reapply!
    update!(
      status: :pending,
      applied_at: Time.zone.now,
      canceled_at: nil
    )
  end

  class AlreadyCanceledError < StandardError; end
end

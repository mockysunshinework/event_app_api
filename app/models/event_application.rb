class EventApplication < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: { pending: 0, confirmed: 1, canceled: 2 }

  # キャンセル可能か
  def cancelable?
    !canceled?
  end

  def cancel!
    raise AlreadyCanceledError if canceled?

    update!(
      status: :canceled,
      canceled_at: Time.current
    )
  end

  class AlreadyCanceledError < StandardError; end
end

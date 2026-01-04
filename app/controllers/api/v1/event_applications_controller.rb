module Api
  module V1
    class EventApplicationsController < ApplicationController
      def create
        current_user = User.first
        event = Event.find_by(id: params[:event_id])
        return render json: { error: "Event not found" }, status: :not_found if event.nil?

        application = EventApplication.new(
          user: current_user,
          event: event,
          status: :pending,
          applied_at: Time.zone.now,
        )

        if application.save
          render json: application.as_json(
            only: %i[id status applied_at canceled_at],
            include: {
              event: {
                only: %i[id title starts_at location]
              }
            }
          ), status: :created
        else
          render json: {
            error: "Validation failed",
            details: application.errors.full_messages,
          },
          status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotUnique
        # UNIQUE(event_id, user_id) に引っかかった場合（同じイベントに二重申込）
        render json: {
          error: "Already exists",
        },
        status: :conflict
      end
    end
  end
end

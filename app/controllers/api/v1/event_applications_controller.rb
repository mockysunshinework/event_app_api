module Api
  module V1
    class EventApplicationsController < ApplicationController
      before_action :authenticate_user!

      def create
        event = Event.find_by(id: params[:event_id])
        return render json: { error: "Event not found" }, status: :not_found if event.nil?

        application = EventApplication.apply_for!(user: current_user, event: event)
        status = application.previously_new_record? ? :created : :ok

        render json: application.as_json(
          only: %i[id status applied_at canceled_at],
          include: {
            event: {
              only: %i[id title starts_at location]
            }
          }
        ), status: status

      rescue ActiveRecord::RecordInvalid => e
        render json: {
          error: "Validation failed",
          details: e.record.errors.full_messages,
        },
        status: :unprocessable_entity
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

module Api
  module V1
    module Me
      class EventApplicationsController < ApplicationController
        before_action :authenticate_user!
        def index
          applications =
            current_user.event_applications
                        .includes(:event)
                        .order(created_at: :desc)

          if params[:status].present? && EventApplication.statuses.key?(params[:status]) == false
            return render json: {
              error: 'Invalid status',
            }, status: :bad_request
          end

          if params[:status].present?
            applications = applications.where(status: params[:status])
          end

          render json: applications.as_json(
            only: %i[id status applied_at canceled_at],
            include: {
              event: {
                only: %i[id title starts_at location]
              }
            }
          )
        end

        def cancel
          application = current_user.event_applications.find_by(id: params[:id])
          return render json: { error: 'Not found' }, status: :not_found if application.nil?

          application.cancel!

          render json: application.as_json(
            only: %i[id status applied_at canceled_at],
            include: {
              event: {
                only: %i[id title starts_at location]
              }
            }
          )
        rescue EventApplication::AlreadyCanceledError
          render json: { error: "Already canceled" }, status: :conflict
        end
      end
    end
  end
end

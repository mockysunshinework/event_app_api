module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(current_user, _opts = {})
          render json: {
            user: {
              id: current_user.id,
              name: current_user.name,
              email: current_user.email
            }
          }, status: :ok
        end

        def respond_to_on_destroy(non_navigational_status: :no_content)
          if request.headers["Authorization"].present?
            render json: { message: "Logged out successfully" }, status: :ok
          else
            render json: { error: "No active session" }, status: :unauthorized
          end
        end
      end
    end
  end
end

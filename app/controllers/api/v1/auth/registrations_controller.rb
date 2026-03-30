module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(current_user, _opts = {})
          if current_user.persisted?
            render json: {
              user: {
                id: current_user.id,
                name: current_user.name,
                email: current_user.email
              }
            }, status: :created
          else
            render json: {
              error: "Registration failed",
              details: current_user.errors.full_messages
            }, status: :unprocessable_entity
          end
        end

        def sign_up_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation)
        end
      end
    end
  end
end

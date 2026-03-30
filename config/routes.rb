Rails.application.routes.draw do
  devise_for :users,
             path: "api/v1/auth",
             path_names: {
               sign_in: "sign_in",
               sign_out: "sign_out",
               registration: "sign_up"
             },
             controllers: {
               sessions: "api/v1/auth/sessions",
               registrations: "api/v1/auth/registrations"
             }

  namespace :api do
    namespace :v1 do
      resources :events, only: [:index] do
        resources :event_applications, only: [:create]
      end

      namespace :me do
        resources :event_applications, only: [:index] do
          member do # resourcesでは自動生成されないアクションをroutesに設定し、idが付与される。
            patch :cancel
          end
        end
      end
    end
  end
end

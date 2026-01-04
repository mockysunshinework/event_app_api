Rails.application.routes.draw do
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

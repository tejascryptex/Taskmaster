Rails.application.routes.draw do
  root "home#index"

  get "reports", to: "reports#index"
  get "tasks/calendar", to: "tasks#calendar", as: "calendar_tasks"

  get "dashboard/index"
  devise_for :users

  resources :projects do
    resources :tasks
  end

  resources :tasks do
    resources :notes, only: [ :create ]
  end

  resources :notes

  resources :tasks do
    post "start_timer", on: :member
    post "stop_timer",  on: :member
  end

  resources :tasks do
    post :update_status, on: :collection
    collection do
    patch :update_due_date
  end
end
end

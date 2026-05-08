Rails.application.routes.draw do
  devise_for :users, skip: [ :registrations ], controllers: { sessions: "users/sessions" }

  get "quienes-somos", to: "public#about", as: :about
  get "cursos", to: "public#courses", as: :courses
  get "tips-ejercicios", to: "public#tips", as: :tips
  get "noticias-recursos", to: "public#news", as: :news
  get "contacto", to: "public#contact", as: :contact

  namespace :portal do
    resources :users, only: %i[index update]
    resources :audit_events, only: :index
    resources :patients do
      resources :clinical_notes, only: :create
      member do
        get "documents/:attachment_id/download", to: "patients#download_document", as: :download_document
      end
    end
    root to: "dashboard#show"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root "home#index"
end

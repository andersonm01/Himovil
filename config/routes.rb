Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"

  resources :phones, path: "inventario"

  resources :sales, path: "ventas"

  resources :credits, path: "creditos", only: [ :index, :show, :edit, :update ] do
    resources :payments, path: "abonos", only: [ :new, :create, :destroy ]
    collection do
      get "abonar", to: "credits#choose_payment", as: "choose_payment"
    end
  end

  get "exportar/inventario.csv", to: "exports#phones", as: :export_phones, defaults: { format: "csv" }
  get "exportar/ventas.csv", to: "exports#sales", as: :export_sales, defaults: { format: "csv" }
  get "exportar/creditos.csv", to: "exports#credits", as: :export_credits, defaults: { format: "csv" }
  get "exportar/abonos.csv", to: "exports#payments", as: :export_payments, defaults: { format: "csv" }

  post "datos_ejemplo/cargar", to: "demo_data#create", as: :load_demo_data
  delete "datos_ejemplo/borrar", to: "demo_data#destroy", as: :destroy_demo_data
end

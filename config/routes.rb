Rails.application.routes.draw do
  get "/v1/alive", to: "api/v1/system#alive"
  get "/v1/me", to: "api/v1/system#me"
  get "/v1/incomes/:income_id", to: "api/v1/incomes#show"
  get "/v1/payments/:payment_id", to: "api/v1/payments#show"
  get "/v1/transactions/:transaction_id/", to: "api/v1/transactions#show"
  get "/v1/user_categories/:user_category_id/", to: "api/v1/user_categories#show"
  get "/v1/users/:user_id/", to: "api/v1/users#show"
  get "/v1/users/:user_id/categories", to: "api/v1/user_categories#index"

  post "/v1/authentications/:authentication_id/authenticate", to: "api/v1/authentications#authenticate"
  post "/v1/users/login", to: "api/v1/users#login"
  post "/v1/users/sign_up", to: "api/v1/users#sign_up"
  post "/v1/users/:user_id/categories", to: "api/v1/user_categories#create"
  post "/v1/users/:user_id/categories/search", to: "api/v1/user_categories#search"
  post "/v1/users/:user_id/incomes", to: "api/v1/incomes#create"
  post "/v1/users/:user_id/incomes/search", to: "api/v1/incomes#search"
  post "/v1/users/:user_id/payments", to: "api/v1/payments#create"
  post "/v1/users/:user_id/payments/search", to: "api/v1/payments#search"

  patch "/v1/incomes/:income_id", to: "api/v1/incomes#update"
  patch "/v1/payments/:payment_id", to: "api/v1/payments#update"
  patch "/v1/user_categories/:user_category_id/", to: "api/v1/user_categories#update"
  patch "/v1/users/:user_id/", to: "api/v1/users#update"

  delete "/v1/user_categories/:user_category_id/", to: "api/v1/user_categories#destroy"
end

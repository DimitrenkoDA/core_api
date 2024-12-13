Rails.application.routes.draw do
  get "/v1/alive", to: "api/v1/system#alive"
  get "/v1/me", to: "api/v1/system#me"
  get "/v1/transactions/:transaction_id/", to: "api/v1/transactions#show"
  get "/v1/users/:user_id/", to: "api/v1/users#show"
  get "/v1/users/:user_id/transactions", to: "api/v1/transactions#index"

  post "/v1/authentications/:authentication_id/authenticate", to: "api/v1/authentications#authenticate"
  post "/v1/users/login", to: "api/v1/users#login"
  post "/v1/users/sign_up", to: "api/v1/users#sign_up"

  patch "/v1/users/:user_id/", to: "api/v1/users#update"
end

Rails.application.routes.draw do
  get "/v1/alive", to: "api/v1/system#alive"
  get "/v1/me", to: "api/v1/system#me"

  post "/v1/authentications/:authentication_id/authenticate", to: "api/v1/authentications#authenticate"
  post "/v1/users/login", to: "api/v1/users#login"
end

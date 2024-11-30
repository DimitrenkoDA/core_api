class ApplicationController < ActionController::API
  before_action { params.permit! }
  before_action :set_locale

  private def set_locale
    I18n.locale = I18n.default_locale
  end
end

class ApplicationHandler
  class Renderer
    def initialize(handler, status: 200)
      @handler = handler
      @status = status
      @formats = {}
    end

    def render
      result = { status: @status }

      if @formats.has_key?(:json)
        result[:json] = @handler.instance_eval(&@formats[:json])
      end

      result
    end

    def json(&block)
      @formats[:json] = block if block_given?
    end
  end

  def self.payload(base_schema = nil, &block)
    if block_given? || base_schema
      klass = Class.new(ApplicationContract) do
        block_given? ? json(base_schema, &block) : json(base_schema)
      end

      @payload_contract = klass.new
    end

    @payload_contract
  end

  def self.params(&block)
    if block_given?
      klass = Class.new(ApplicationContract) do
        params(&block)
      end

      @params_contract = klass.new
    end

    @params_contract
  end

  attr_reader :params
  attr_reader :payload
  attr_reader :errors
  attr_reader :controller

  def initialize(controller, **args)
    @errors = Errors::Error.new

    if self.class.params.present?
      result = self.class.params.call(controller.params.to_h)

      if result.failure?
        @errors << Errors::Error.new(attributes: result.errors(full: true).to_h)
      end

      @params = result.to_h
    end

    if self.class.payload.present?
      result = self.class.payload.call(controller.params.to_h)

      if result.failure?
        @errors << Errors::Error.new(attributes: result.errors(full: true).to_h)
      end

      @payload = result.to_h
    end

    @controller = controller
  end

  def handle!
    if @errors.present?
      render status: 422 do
        json { @errors }
      end

      return
    end

    handle
  rescue Errors::AccessDenied => error
    render status: 401 do
      json { Errors::Error.alert(error.message) }
    end
  rescue Errors::ActionForbidden => error
    render status: 403 do
      json { Errors::Error.alert(error.message) }
    end
  rescue ActiveRecord::RecordNotFound
    render status: 404 do
      json { Errors::Error.alert("Not Found") }
    end
  rescue ActiveRecord::RecordNotUnique
    render status: 422 do
      json { Errors::Error.alert("Entity already exists") }
    end
  end

  def handle
    render status: 204
  end

  protected def authenticate!
    access_denied!(message: "Authentication required!") unless authenticated?
  end

  protected def authenticated?
    current_session.present? && current_session.valid?
  end

  protected def access_denied!(message: nil)
    raise Errors::AccessDenied, message || "Access Denied!"
  end

  protected def forbidden!(message: nil)
    raise Errors::ActionForbidden, message || "Action forbidden!"
  end

  protected def current_session
    if access_token.present?
      @current_session ||= System::Session.new(access_token)
    end
  end

  protected def access_token
    @access_token ||= headers["X-Access-Token"]
  end

  protected def headers
    @controller.request.headers
  end

  protected def render(status: 200, &block)
    unless block_given?
      @controller.render status: status
      return
    end

    renderer = ApplicationHandler::Renderer.new(self, status: status)
    renderer.instance_eval(&block) if block_given?

    @controller.render renderer.render
  end
end

module ErrorHandlingMiddleware

  class ParsingFailureToJSON < ActionController::Metal

    def initialize app
      @app = app
    end

    def call env
      begin
        @app.call(env)
      rescue ActionDispatch::ParamsParser::ParseError => e
        ApiErrorsController.action(:parse_error).call(env)
      rescue => e
        ApiErrorsController.action(:dispatch_error).call(env)
      end
    end

  end

end
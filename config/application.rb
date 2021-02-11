require File.expand_path('../boot', __FILE__)
require "rails"
require "active_job/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_record/railtie"
# require "action_mailer/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Porkerhands
  class Application < Rails::Application

    # service settings
    config.autoload_paths += %W(#{config.root}/app/services)

    # api settings
    config.paths.add File.join('app', 'api'), glob: File.join('**', '*.rb')
    config.autoload_paths += Dir[Rails.root.join('app', 'api', '*')]
    config.autoload_paths += %W(#{config.root}/app/api/v1/lib)

    config.time_zone = 'Tokyo'
    config.i18n.default_locale = :ja

    # JSONが壊れている場合のエラーハンドリング
    config.middleware.insert_before ActionDispatch::ParamsParser, "ErrorHandlingMiddleware::ParsingFailureToJSON"

  end
end

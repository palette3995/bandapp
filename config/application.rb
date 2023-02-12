require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bandapp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    # 日本語化の設定
    config.i18n.default_locale = :ja

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    # タイムゾーンの変更
    config.time_zone = "Asia/Tokyo"
    # config.eager_load_paths << Rails.root.join("extras")
    # mini_magickを指定
    config.active_storage.variant_processor = :mini_magick
  end
end

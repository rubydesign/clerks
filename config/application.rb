require_relative 'boot'

require "rails"

# Include each railties manually, excluding `active_storage/engine`
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require "bcrypt"

module Rubydesign
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.cache_store = :memory_store, { size: 64.megabytes }
    config.eager_load = true
    config.eager_load_paths << Rails.root.join('lib')
    #config.autoload_paths += %W( lib/ )
    config.middleware.use Rack::Attack
    config.i18n.available_locales = :fi , :config
    config.i18n.default_locale = :fi
    config.require_master_key = true
    config.active_record.use_yaml_unsafe_load = true

    config.blog_path = Rails.root.to_s + "/app/views/posts"

  end
end

require "ruby2js"
require "ruby2js/es2015"
require "ruby2js/filter/functions"
require "ruby2js/haml"
require "ruby2js/filter/vue"

module RubyClerks
  # Configuration is stored in locale/config.yml under the main key (ie "locale") config
  # You can add to it, or redifine it, just like you do to locale data, by adding a locale file to your app
  #  with config locale and the keys you need
  def self.config key
    I18n.t(key , :locale => :config)
  end
end

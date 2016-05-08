# Be sure to restart your server when you modify this file.

options = {
  key: "_content_saas_session"
}

case Rails.env
when "development", "test"
  options.merge!(domain: "lvh.me")
when "production"
  #options.merge!(domain: "whateveryourdomainis.com")
end

Rails.application.config.session_store :cookie_store, options

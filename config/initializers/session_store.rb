# Be sure to restart your server when you modify this file.

AeonVera::Application.config.session_store(
  :active_record_store,
  key: "_#{Rails.env}_aeonvera_system_session",
  domain: :all,
  secure: Rails.env.production?
)

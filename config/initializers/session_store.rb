Rails.application.config.session_store :cookie_store,
  key: "_narratree_session",
  secure: Rails.env.production?,
  same_site: :lax,
  domain: (Rails.env.production? ? [ "narratree.onrender.com", "narratree.net" ] : nil)

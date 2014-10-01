# Be sure to restart your server when you modify this file.

MovieGenie::Application.config.session_store :cookie_store,
     key: '_MovieGenie_session', 
    :expire_after => 7.days

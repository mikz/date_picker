# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_DatePicker_session',
  :secret      => '4e6fda96f13dd8e3677c5acda7e4158a94ea0192d1f3d9169b88bdb0c4e1b4432a813a8cb6c5880ad78b9d309304f46ced2773566414a9763e611b9cbfd7e65c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

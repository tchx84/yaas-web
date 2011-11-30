# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_application_session',
  :secret      => 'ac7f20c0cf9a80ffd6a2f52d1cbce4b6a38074db18772cfa3f2d528a4978a90d1a404fc6685f0f4d149c2baa00d9eddae3409aace31b08ad823c032c6a2ba295'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

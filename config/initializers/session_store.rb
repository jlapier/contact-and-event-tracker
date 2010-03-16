# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_contact_tracker_session',
  :secret      => 'dc03677e8f991e34f7b47db43ab819fddcf4825652f90f0624967ed8895b139a2d82829030228c9de8b5216351db4e44b0f1145dd8f8d778ad1e812c141358f5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

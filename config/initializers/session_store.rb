# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_biblepeople.info_session',
  :secret      => '84e9218010fcae0b2aef4d491fdc1df42cb67197859fdf8463d523f0c0dd026e028ae9be518cb5670910dfb6d18833926e49a588c579ecf500a2068ff60348f5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

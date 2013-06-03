configatron.configure_from_yaml("#{Rails.root}/config/config.yml", :hash => Rails.env)
configatron.configure_from_yaml("#{Rails.root}/config/twitter_keys.yml", :hash => Rails.env)

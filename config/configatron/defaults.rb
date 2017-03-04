# TODO : 4.1化の際に、secret.yml機構で置き換え
config_hash = YAML.load_file("#{Rails.root}/config/configatron/secret.yml")[Rails.env]
configatron.configure_from_hash(config_hash)

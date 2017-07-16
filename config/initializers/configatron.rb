require 'configatron'
Configatron::Integrations::Rails.init unless Rails.env.test? # travis ci で rspec 実行時に secret.yml が読み込めないのを回避（git ignoredな為）

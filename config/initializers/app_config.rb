require 'ostruct'
require 'yaml'

config = OpenStruct.new(
  YAML.load_file(Rails.root.join('config', 'app_config.yml'))
)

::AppConfig = OpenStruct.new(config.public_send(Rails.env))

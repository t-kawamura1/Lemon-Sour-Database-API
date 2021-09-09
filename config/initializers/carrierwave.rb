require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = true
  end
end

CarrierWave.configure do |config|
  config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_directory = ENV['S3_BUCKET_NAME']
  config.fog_public = false
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['S3_REGION'],
    path_style: true,
  }
end

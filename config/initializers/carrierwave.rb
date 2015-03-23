CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region:                ENV['AWS_REGION']
  }
  if Rails.env.production?
    config.fog_directory  = ENV['AWS_S3_BUCKET_PRODUCTION']
  elsif Rails.env.staging?
    config.fog_directory  = ENV['AWS_S3_BUCKET_STAGING']
  else
    config.fog_directory  = ENV['AWS_S3_BUCKET_DEVELOPMENT']
  end
end
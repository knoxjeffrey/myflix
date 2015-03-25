CarrierWave.configure do |config|
  config.storage    = :aws
  config.aws_acl    = :public_read
  config.aws_credentials = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    #config: AWS.config(my_aws_options)
    #region:            ENV.fetch('AWS_REGION')
  }
  if Rails.env.production?
    config.aws_bucket  = ENV.fetch('AWS_S3_BUCKET_PRODUCTION')
  elsif Rails.env.staging?
    config.aws_bucket  = ENV.fetch('AWS_S3_BUCKET_STAGING')
  else
    config.aws_bucket  = ENV.fetch('AWS_S3_BUCKET_DEVELOPMENT')
  end
end

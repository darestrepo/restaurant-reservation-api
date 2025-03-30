# frozen_string_literal: true

require 'aws-sdk-s3'

Aws.config.update({
  region: ENV['AWS_REGION'] || 'us-east-1',
  credentials: Aws::Credentials.new(
    ENV['AWS_ACCESS_KEY_ID'] || 'your_access_key_id',
    ENV['AWS_SECRET_ACCESS_KEY'] || 'your_secret_access_key'
  )
})

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET'] || 'your-bucket-name') 
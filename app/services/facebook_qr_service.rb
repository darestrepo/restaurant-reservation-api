# frozen_string_literal: true

require 'httparty'
require 'open-uri'

class FacebookQrService
  include HTTParty
  base_uri 'https://graph.facebook.com'
  format :json
  
  attr_reader :phone_id, :token, :api_version
  
  def initialize(phone_id, token)
    @phone_id = phone_id
    @token = token
    @api_version = ENV['FACEBOOK_API_VERSION'] || 'v18.0'
  end
  
  def generate_qr_code(message)
    response = self.class.post(
      "/#{api_version}/#{phone_id}/message_qrdls",
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{token}"
      },
      body: {
        prefilled_message: message,
        generate_qr_image: 'PNG'
      }.to_json
    )
    
    if response.success?
      response.parsed_response
    else
      Rails.logger.error("Facebook QR API error: #{response.code} - #{response.body}")
      raise "Failed to generate QR code: #{response.code} - #{response.message}"
    end
  end
  
  def upload_qr_to_s3(qr_url, hash_id)
    file_name = "qr_#{hash_id}.png"
    
    begin
      # Download the file from Facebook URL
      image_data = URI.open(qr_url).read
      
      # Upload to S3 without ACL (bucket policy makes it public)
      object = S3_BUCKET.object(file_name)
      object.put(
        body: image_data,
        content_type: 'image/png'
      )
      
      # Return the public URL 
      object.public_url
    rescue => e
      Rails.logger.error("S3 upload error: #{e.message}")
      raise "Failed to upload QR to S3: #{e.message}"
    end
  end
end 
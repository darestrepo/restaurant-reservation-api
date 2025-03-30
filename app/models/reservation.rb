# frozen_string_literal: true

class Reservation < ApplicationRecord
  belongs_to :guest
  belongs_to :restaurant

  validates :status, :start_time, :covers, presence: true

  enum status: %i[requested pending booked ended cancelled]
  
  before_create :generate_hash_id
  before_create :generate_qr_code
  
  private
  
  def generate_hash_id
    # Format: DDMMYY_XXXXX where XXXXX is a 5-character alpha random hash
    Rails.logger.info("Start time for reservation: #{start_time.inspect}")
    Rails.logger.info("Start time class: #{start_time.class}")
    
    # Ensure we're using the correct date format
    day = start_time.day.to_s.rjust(2, '0')
    month = start_time.month.to_s.rjust(2, '0')
    year = (start_time.year % 100).to_s.rjust(2, '0')
    
    date_part = "#{day}#{month}#{year}"
    Rails.logger.info("Generated date parts - day: #{day}, month: #{month}, year: #{year}")
    Rails.logger.info("Final date_part: #{date_part}")
    
    # Generate a 5-character random string using alphanumeric characters
    alpha_chars = ('A'..'Z').to_a + ('a'..'z').to_a
    random_part = 5.times.map { alpha_chars.sample }.join
    
    # Combine date_part and random_part with underscore
    self.hash_id = "#{date_part}_#{random_part}"
    Rails.logger.info("Final hash_id: #{self.hash_id}")
  end
  
  def generate_qr_code
    if !restaurant
      Rails.logger.info("QR code not generated: restaurant association is nil")
      return
    elsif !restaurant.channel_phone_id.present?
      Rails.logger.info("QR code not generated: restaurant channel_phone_id is missing")
      return
    elsif !restaurant.channel_token.present?
      Rails.logger.info("QR code not generated: restaurant channel_token is missing")
      return
    end
    
    Rails.logger.info("Generating QR code with phone_id: #{restaurant.channel_phone_id}, hash_id: #{hash_id}")
    
    begin
      service = FacebookQrService.new(restaurant.channel_phone_id, restaurant.channel_token)
      response = service.generate_qr_code(hash_id)
      
      if response && response['qr_image_url']
        Rails.logger.info("QR code generated successfully, uploading to S3...")
        s3_url = service.upload_qr_to_s3(response['qr_image_url'], hash_id)
        self.qr_code_image = s3_url
        Rails.logger.info("QR code uploaded to S3: #{s3_url}")
      else
        Rails.logger.error("Facebook API response missing qr_image_url: #{response.inspect}")
      end
    rescue => e
      Rails.logger.error("QR code generation error: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      # Don't stop creation if QR generation fails
    end
  end
end

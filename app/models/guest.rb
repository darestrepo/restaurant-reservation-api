# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :restaurant

  validates :phone, :email, presence: true
  
  validate :name_present
  
  before_save :set_names
  
  def name
    full_name.presence || [first_name, last_name].select(&:present?).join(' ')
  end
  
  private
  
  def name_present
    if full_name.blank? && first_name.blank? && last_name.blank?
      errors.add(:base, "Either full name or first name and last name must be provided")
    end
  end
  
  def set_names
    if full_name.present? && first_name.blank? && last_name.blank?
      name_parts = full_name.split
      if name_parts.size >= 2
        self.first_name = name_parts[0]
        self.last_name = name_parts[1..-1].join(' ')
      end
    elsif full_name.blank? && first_name.present? && last_name.present?
      self.full_name = "#{first_name} #{last_name}"
    end
  end
end

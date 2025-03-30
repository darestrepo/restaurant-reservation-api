# frozen_string_literal: true

class Guest < ApplicationRecord
  has_many :reservations, dependent: :destroy
  belongs_to :restaurant

  validates :first_name, :last_name, :phone, :email, presence: true
  
  # JSON columns are already serialized by Rails, no need for additional serialization
end

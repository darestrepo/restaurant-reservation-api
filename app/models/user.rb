# frozen_string_literal: true

class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  belongs_to :restaurant, optional: true, validate: false
  
  enum role: %i[admin restaurant guest]
  
  # Helper methods to check user roles
  def admin?
    role == 'admin' || role == 0
  end
  
  def restaurant?
    role == 'restaurant' || role == 1
  end
  
  def guest?
    role == 'guest' || role == 2
  end
end

# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_authorization_check
  respond_to :json
end 
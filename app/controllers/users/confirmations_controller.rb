# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_authorization_check
  respond_to :json
end 
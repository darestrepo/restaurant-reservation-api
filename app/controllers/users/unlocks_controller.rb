# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  skip_authorization_check
  respond_to :json
end 
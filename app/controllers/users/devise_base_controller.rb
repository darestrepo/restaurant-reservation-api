# frozen_string_literal: true

class Users::DeviseBaseController < ApplicationController
  skip_authorization_check
  respond_to :json
end 
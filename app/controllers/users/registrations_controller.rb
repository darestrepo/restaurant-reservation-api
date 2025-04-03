# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_authorization_check
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  respond_to :json

  # POST /resource
  def create
    # Log the parameters to debug
    Rails.logger.info "Registration params: #{params.inspect}"
    
    begin
      # Build user with sanitized parameters
      build_resource(sign_up_params)
      
      # Set attributes explicitly to bypass potential nested validation issues
      if params[:user]
        resource.restaurant_id = params[:user][:restaurant_id] if params[:user][:restaurant_id].present?
        resource.restaurant_id = params[:user][:restaurant] if params[:user][:restaurant].present?
        resource.active = params[:user][:active] unless params[:user][:active].nil?
        resource.role = params[:user][:role] if params[:user][:role].present?
        resource.name = params[:user][:name] if params[:user][:name].present?
        resource.job = params[:user][:job] if params[:user][:job].present?
      end
      
      # Log what we're about to save
      Rails.logger.info "About to save user with attrs: #{resource.attributes.inspect}"
      
      # Save with validation
      if resource.save
        Rails.logger.info "User saved successfully with ID: #{resource.id}"
        
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up if is_flashing_format?
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      else
        Rails.logger.error "User save failed with errors: #{resource.errors.full_messages.inspect}"
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    rescue => e
      Rails.logger.error "Registration exception: #{e.class}: #{e.message}\n#{e.backtrace.join("\n")}"
      render json: { error: "Registration failed: #{e.message}" }, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:restaurant_id, :restaurant, :active, :role, :name, :job])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:restaurant_id, :restaurant, :active, :role, :name, :job])
  end

  # Override sign_up_params to be more flexible
  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :restaurant_id, :restaurant, :active, :role, :name, :job)
  end
end 
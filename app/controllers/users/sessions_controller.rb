# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_authorization_check
  
  # Set the response formats
  respond_to :json
  
  # Skip authentication for sign_in but enforce it for sign_out
  acts_as_token_authentication_handler_for User, except: [:create]
  
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    
    # Return the user with their authentication token
    render json: {
      id: resource.id,
      email: resource.email,
      authentication_token: resource.authentication_token,
      role: resource.role,
      restaurant_id: resource.restaurant_id,
      active: resource.active,
      name: resource.name,
      job: resource.job
    }, status: :ok
  end
  
  # DELETE /resource/sign_out
  def destroy
    # Check if user is authenticated
    if current_user
      # Optional: Invalidate the authentication token
      # Uncomment this line if you want to invalidate the token on sign out
      # current_user.update_attribute(:authentication_token, nil)
      
      # Sign the user out using Devise's built-in method
      signed_out = sign_out(current_user)
      
      # Return a success message
      render json: { message: "Signed out successfully" }, status: :ok
    else
      # If no user is authenticated, return unauthorized status
      render json: { error: "Not authenticated" }, status: :unauthorized
    end
  end
  
  # Override the default verify_signed_out_user to prevent errors
  # when the user is already signed out
  protected
  
  def verify_signed_out_user
    # Skip the verification to avoid errors
  end
  
  # This ensures Devise's respond_to_on_destroy works correctly
  private
  
  def respond_to_on_destroy
    # Using our own response logic in destroy method
    # Skip Devise's default behavior
  end
end 
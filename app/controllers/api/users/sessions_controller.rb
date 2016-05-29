class Api::Users::SessionsController < Devise::SessionsController
  require 'auth_token'

  # Disable CSRF protection
  skip_before_action :verify_authenticity_token

  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?

    token = AuthToken.issue_token({ id: resource.id, email: resource.email })
    respond_to do |format|
      format.json { render json: {token: token} }
    end
  end
end
class SandboxController < ApplicationController
# ensure_authenticated_to_facebook [:except => 'index'] 
  def index 
    @current_facebook_user = facebook_session.user
  end
  def user_info
    
  end
end
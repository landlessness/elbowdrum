class SandboxController < ApplicationController
  ensure_authenticated_to_facebook [:except => 'index'] 
  def index 
  end
  def look_at_user_data
     @current_facebook_user = facebook_session.user
  end
end
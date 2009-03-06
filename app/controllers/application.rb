# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'aasm'
  helper :all # include all helpers, all the time
  include AuthenticatedSystem
  before_filter :set_person_time_zone
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5f0f6435f9d1e298998cb96ec70a8e01'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  private
  
  def set_person_time_zone
    Time.zone = current_person.time_zone if logged_in?
  end
end

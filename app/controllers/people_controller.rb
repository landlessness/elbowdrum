class PeopleController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_person, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :login_required, :only => [:profile, :show, :index]
  
  def index
    respond_to do |format|
      format.html
      format.xml { render :xml => @thought }
    end
  end

  def profile
    @person = current_person
    components @person
    respond_to do |format|
      format.html { render :action => 'show'}
      format.xml  { render :xml => @thought }
    end
  end
  
  # render new.rhtml
  def show
    @person = Person.find params[:id]
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @thought }
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.xml  { render :xml => @thought }
    end    
  end
 
  def edit_password
    respond_to do |format|
      format.html
      format.xml  { render :xml => @thought }
    end    
  end
 
  def edit_email
    respond_to do |format|
      format.html
      format.xml  { render :xml => @thought }
    end    
  end
 
  def update_password
    success = current_person.update_attributes(params[:person]) if current_person.crypted_password == current_person.encrypt(params[:old_password])
    if success
      flash[:notice] = 'Successfully updated password'
      redirect_to edit_person_url(current_person)
    else
      flash[:error] = 'Password was not updated.  Your old password was incorrect or your new password was invalid.'
      render :action => 'edit_password'
    end
  end
 
  def update_email
    mode = params[:current_person][:email].blank? ? :new : :existing
    case mode
    when :new
      @email = current_person.emails.create :email => params[:email]
      if @email
        @email.add!
        render :action => 'email_sent'
      else
        flash[:error] = 'Email was not changed.'
        render :action => 'edit_email'
      end
    when :existing
      success = current_person.update_attributes(params[:current_person])
      if success
        flash[:notice] = 'Successfully changed email'
        redirect_to edit_person_url(current_person) 
      else
        flash[:error] = 'Email was not changed.'
        render :action => 'edit_email'
      end
    end
  end

  def confirm
    @email = Email.find_by_confirmation_code params[:confirmation_code]
    case
    when (!params[:confirmation_code].blank?) && @email && !@email.confirmed?
      @email.confirm!
      @email.person.activate! unless @email.person.active?
      @message = 'Successfully confirmed email, <strong>' + @email.email + '</strong>'
    when params[:confirmation_code].blank?
      @message = "The confirmation code was missing.  Please follow the URL from your email."
    else 
      @message = "We couldn't find an email with that confirmation code -- check your email? Or maybe you've already confirmed -- try signing in to check."
    end
  end
 
  def hide_tips
    if current_person.id == params[:id].to_i
      current_person.update_attributes :hide_tips => true
      respond_to do |format|
        format.js
      end
    end 
  end
 
  # render new.rhtml
  def new
    @person = Person.new :color => 'FFFFFF', :email => ''
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @thought }
    end
  end
 
  def update
    success = current_person.update_attributes(params[:person])
    if success
      flash[:notice] = 'Successfully updated settings'
      redirect_to home_url
    else
      flash[:error] = 'Settings were not updated'
      render :action => 'edit'
    end
  end

  def create
    logout_keeping_session!
    @person = Person.new(params[:person])
    saved = @person.save
    if @person.valid? && saved && @person.register!
      @email = @person.emails.first
      render :action => 'email_sent'
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def signup_success
    @person = Person.find params[:id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def email_sent
    @person = Person.find params[:id]
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def activate

    logout_keeping_session!
    person = Person.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && person && !person.active?
      person.activate!
      redirect_to(signup_success_person_url(person))
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a person with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end

  def suspend
    @person.suspend! 
    redirect_to people_path
  end

  def unsuspend
    @person.unsuspend! 
    redirect_to people_path
  end

  def destroy
    @person.delete!
    redirect_to people_path
  end

  def purge
    @person.destroy
    redirect_to people_path
  end
  
  def login_valid
    person = Person.find_by_login(params[:login])
    if person.nil?
      person = Person.new(:login => params[:login])
      valid = person.validate_attributes(:only => ['login'])
      text = valid ? 'valid & available' : 'invalid'
      render :text => text
    elsif current_person && person == current_person
      render :text => 'valid & available'
    else
      render :text => 'unavailable'
    end
  end

  def email_valid
    email = Email.find_by_email(params[:email])
    if email.nil?
      email = Email.new(:email => params[:email])
      valid = email.validate_attributes(:only => ['email'])
      text = valid ? 'valid & available' : 'invalid'
      render :text => text
    elsif current_person && current_person.emails.include?(email)
      render :text => 'already registered'
    else
      render :text => 'unavailable'
    end
  end

  # There's no page here to update or destroy a person.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_person
    @person = Person.find(params[:id])
  end
end

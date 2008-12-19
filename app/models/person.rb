require 'digest/sha1'

class Person < ActiveRecord::Base
  DEFAULT_AVATAR = 'http://www.tictocbloc.com/images/avatar.png'

  has_many :emails
  belongs_to :current_email, :class_name => "Email"
  
  has_many :account_memberships
  has_many :accounts, :through => :account_memberships

  has_many :team_memberships
  has_many :teams, :through => :team_memberships

  belongs_to :current_account, :class_name => "Account"

  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::AasmRoles
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :message => 'that screen name has already been taken'
  validates_format_of       :login,    :with => /^[A-Z0-9._%+-]+$/i, :message => 'screen name should have no spaces'

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100


  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :name, :password, :password_confirmation, :email, :current_email

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_in_state :first, :active, :joins => :emails, :conditions => ['emails.email = ?', email]
    u = find(u.id) if u
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email
    current_email.nil? ? '' : current_email.email
  end
  
  def email=(value)
    e = self.emails.find_by_email value
    if e
      self.current_email = e if e.confirmed?
    else
      self.new_record? ? self.emails.build(:email => value) : self.emails.create(:email => value)
    end
  end
  
  def do_activate
    self.deleted_at = nil
  end
  
  protected

  def make_activation_code
    self.deleted_at = nil
    emails.first.add!
  end

end

class Email < ActiveRecord::Base
  include AASM
  belongs_to :person

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => /\A#{email_name_regex}@#{domain_head_regex}#{domain_tld_regex}\z/i, :message => Authentication.bad_email_message

  aasm_column :state
  aasm_initial_state :initial => :pending

  aasm_state :passive
  aasm_state :pending, :enter => :do_pending
  aasm_state :confirmed, :enter => :do_confirm

  aasm_event :add do
    transitions :from => :passive, :to => :pending
  end

  aasm_event :confirm do
    transitions :from => :pending, :to => :confirmed
  end

  def do_pending
    make_confirmation_code
    PersonMailer.deliver_email_confirmation(self)
  end

  def do_confirm
    self.confirmed_at = Time.now.utc
    self.deleted_at = self.confirmation_code = nil
    self.person.update_attributes :current_email => self
  end

  def make_confirmation_code
    self.deleted_at = nil
    self.confirmation_code = Person.make_token
  end
end

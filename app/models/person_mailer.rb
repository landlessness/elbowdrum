class PersonMailer < ActionMailer::Base
  def email_confirmation(email)
    @recipients  = "#{email.email}"
    @from        = "support@elbowdrum.com"
    @subject     = "Elbow Drum Contact Email Confirmation"
    @sent_on     = Time.now
    @body[:person] = email.person
    @body[:url]  = "http://#{Rails::Initializer::TLD}/confirm/#{email.confirmation_code}"
  end
end

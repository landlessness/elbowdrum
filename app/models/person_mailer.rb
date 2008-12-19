class PersonMailer < ActionMailer::Base
  def email_confirmation(email)
    @recipients  = "#{email.email}"
    @from        = "support@tictocbloc.com"
    @subject     = "Tic Toc Bloc Contact Email Confirmation"
    @sent_on     = Time.now
    @body[:person] = email.person
    @body[:url]  = "http://#{Rails::Initializer::TLD}/confirm/#{email.confirmation_code}"
  end
end

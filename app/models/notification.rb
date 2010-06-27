class Notification < ActionMailer::Base
  
  default_url_options[:host] = "localhost"
  default_url_options[:port] = "3000"
  
  def password_reset_confirmation(user)
    subject "Confirm password reset request"
    from "test@example.com"
    recipients user.email
    sent_on Time.now
    body({
      :confirmation_url => password_reset_url(user.perishable_token)
    })
  end
end
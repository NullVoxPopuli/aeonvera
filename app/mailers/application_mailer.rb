class ApplicationMailer < ActionMailer::Base
  default from: APPLICATION_CONFIG['support_email']
  layout "email"
end

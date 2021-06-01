# frozen_string_literal: true
require_relative '../pages/login_email'
require_relative '../pages/login_password'

module Login
  def log_in_as(email_address:, password: ENV['DEFAULT_PASSWORD'], login_email: LoginEmail.new(@driver), login_password: LoginPassword.new(@driver))
    login_email.get ''
    expect(login_email.page_displayed?).to be_truthy

    login_email.submit(email_address)
    expect(login_password.page_displayed?).to be_truthy

    login_password.submit(password)
  end
end

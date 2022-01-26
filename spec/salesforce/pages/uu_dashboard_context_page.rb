
require_relative '../../shared_components/base_page'

require 'date'

class UuDashboardContextPage < BasePage

  EMAIL_INPUT = {css: 'username'}.freeze # css: '#email-0'
  PASSWORD_INPUT = {css: 'password'}.freeze
  VERIFICATION_CODE_INPUT = {id: 'emc'}.freeze
  VERIFY_YOUR_IDENTITY = {id: 'save'}.freeze

  LOGIN_BTN = { css: 'Login' }.freeze

  def page_displayed?
    is_displayed?(VERIFY_YOUR_IDENTITY)
  end

  def submit_form
    this.LOGIN_BTN.click
  end
end

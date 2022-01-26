require_relative '../../shared_components/base_page'

require 'date'

class SalesforceLandingPage < BasePage

  LANDING_PAGE_LOGO = {css: '#slds-assistive-text'}.freeze # css: '#email-0'
  LANDING_PAGE_URL = 'https://uniteus4.lightning.force.com/lightning/page/usage'

  def page_displayed?
    is_displayed?(LANDING_PAGE_LOGO)
  end
end

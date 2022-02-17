# frozen_string_literal: true

require_relative '../../shared_components/base_page'
require 'page-object'
require 'date'

class SalesforceLandingPage < BasePage

  LANDING_PAGE_LOGO = { css: '#slds-global-header__logo' }.freeze # css: '#email-0'
  LANDING_PAGE_URL = 'https://uniteus4.lightning.force.com/lightning/page/usage'
  LANDING_PAGE_WAFFLE = { css: 'slds-icon-waffle' }.freeze


  def page_displayed?
    is_displayed?(LANDING_PAGE_WAFFLE)
  end

  def select_patient
    find_elements(PATIENT_ID)
    click(PATIENT_ID)
  end

  def validate_signed_request_params
    put 'hello'
  end
end

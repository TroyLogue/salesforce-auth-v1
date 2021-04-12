# frozen-string-literal: true

require_relative '../../shared_components/base_page'

class Consent < BasePage
  ACCEPT_BTN = { css: '#accept' }
  CONSENT_EXPIRED_CONTAINER = { css: '#not-found-container' }
  CONSENT_AGREEMENT_CONTAINER = { css: '#agreement-container' }
  CONSENT_AGREEMENT_HEADER = { css: '#agreement-container h3' }
  CONSENT_AGREEMENT_HEADER_TEXT = "Consent to Participate in the Unite Us Network"
  DECLINE_BTN = { css: '#decline' }
  MAIN_CONTAINER = { css: '.global-consent' }
  SIGNATURE_PAD = { css: '#signature-pad' }

  def get_consent_page(token:)
    base_url = ENV['consent_url']
    consent_url = base_url + '/?' + token
    driver.get consent_url
  end

  def page_displayed?
    is_displayed?(MAIN_CONTAINER)
  end

  def consent_agreement_displayed?
    is_displayed?(CONSENT_AGREEMENT_CONTAINER) &&
      text_include?(CONSENT_AGREEMENT_HEADER_TEXT, CONSENT_AGREEMENT_HEADER) &&
      is_displayed?(SIGNATURE_PAD) &&
      is_displayed?(ACCEPT_BTN) &&
      is_displayed?(DECLINE_BTN)
  end

  def consent_expired_displayed?
    is_displayed?(CONSENT_EXPIRED_CONTAINER)
  end

end

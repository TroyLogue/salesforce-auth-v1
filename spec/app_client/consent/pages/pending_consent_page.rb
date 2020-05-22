require_relative '../../../shared_components/base_page'

class PendingConsentPage < BasePage
  CONSENT_MODAL = { css: '#consent-dialog' }
  FILTERS_BAR = { css: '.filter-bar' }
  PENDING_CONSENT_REFERRAL_FIRST = { css: '.ui-table-body tr:nth-of-type(1)' }
  PENDING_CONSENT_REFERRAL_SECOND = { css: '.ui-table-body tr:nth-of-type(2)' }
  REFERRALS_TABLE = { css: '.dynamic-table' }
  REQUEST_OR_UPLOAD_CONSENT_BUTTON = { css: '#vertical-dots-menu-item-0' }
  VERTICAL_DOTS_MENU_FIRST = { css: '#-pending-consent-referrals-table-row-0 #vertical-dots-menu' }
  VERTICAL_DOTS_MENU = { css: '#vertical-dots-menu' }

  def consent_modal_displayed?
    is_displayed?(CONSENT_MODAL)
  end

  def consent_modal_not_displayed?
    is_not_displayed?(CONSENT_MODAL)
  end

  def open_first_consent_modal
    click(VERTICAL_DOTS_MENU)
    click(REQUEST_OR_UPLOAD_CONSENT_BUTTON)
    sleep(1) #waiting for slide in animation
  end

  def page_displayed?
    is_displayed?(FILTERS_BAR)
    is_displayed?(REFERRALS_TABLE)
  end

  def text_of_first_referral()
    return text(PENDING_CONSENT_REFERRAL_FIRST)
  end

  def text_of_second_referral()
    return text(PENDING_CONSENT_REFERRAL_SECOND)
  end
end

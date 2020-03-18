require_relative '../../../shared_components/base_page'

class PendingConsentPage < BasePage

  FILTERS_BAR = { css: '.filter-bar' } 
  REFERRALS_TABLE = { css: '.dynamic-table' }
  PENDING_CONSENT_REFERRAL = { css: '.ui-table-body.tr' }
  PENDING_CONSENT_REFERRAL_FIRST = { css: '.ui-table-body.tr:nth-of-type(1)'}

  VERTICAL_DOTS_MENU = { css: '#vertical-dots-menu' }
  REQUEST_OR_UPLOAD_CONSENT_BUTTON = { css: '#vertical-dots-menu-item-0' } 

  def nth_pending_consent_referral(row_number: 1) 
    return { css: ".ui-table-body.tr:nth-of-type(#{row_number})" } 
  end 

  def open_consent_modal 
    click(VERTICAL_DOTS_MENU) 
    click(REQUEST_OR_UPLOAD_CONSENT_BUTTON) 
  end

  def page_displayed? 
    is_displayed?(FILTERS_BAR) 
    is_displayed?(REFERRALS_TABLE)
  end

  def text_of_nth_referral(row_number: 1) 
    return text(nth_pending_consent_referral(row_number))  
  end 

end

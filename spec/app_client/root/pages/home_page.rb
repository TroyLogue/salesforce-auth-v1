require_relative '../../../shared_components/base_page'

class HomePage < BasePage

    NEW_REFERRAL_BTN = { css: '#incoming-new-referrals-tab' }
    NEW_AR_BTN = { css: '#incoming-assistance-requests-tab' }
    INCOMING_PENDING_BTN = { css: '#incoming-pending-consent-tab' }
    ASSIGNED_IN_REVIEW = { css: '#assigned-in-referrals-tab' }
    ASSIGNED_RECALL_BTN = { css: '#assigned-recalled-referrals-tab' }
    REFERRAL_PENDING_BTN = { css: '#referred-out-pending-consent-tab' }
    REFERRAL_NEEDS_ACTION_BTN = { css: '#referred-out-needs-action-tab' }
    REFERRAL_REJECTED_BTN = { css: '#referred-out-rejected-referrals-tab' }
    OPEN_CASES_BTN = { css: '#assigned-open-cases-tab' }
    CLOSED_CASE_BTN = { css: '#assigned-closed-cases-tab' }
    TIMELINE = { css: '.activity-stream' }
    INTERCOM_IFRAME = { css: '.intercom-launcher-frame' }
    # Revisit INTERCOM_BTN selector once selector migration plan is complete
    INTERCOM_BTN = { css: '.intercom-launcher' }
    CLOSE_INTERCOM_BTN = INTERCOM_BTN

    AR_OVERFLOW_MENU = { css: '#vertical-dots-menu' }
    AR_REQUEST_OR_UPLOAD_CONSENT_BUTTON = { css: '#vertical-dots-menu-item-0' } 

    def open_consent_modal 
      click(AR_OVERFLOW_MENU) 
      click(AR_REQUEST_OR_UPLOAD_CONSENT_BUTTON) 
    end

end

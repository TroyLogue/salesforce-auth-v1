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
  TIMELINE_LOADING = { css: '.loading-entries__content' }
  INTERCOM_IFRAME = { css: '.intercom-launcher-frame' }
  INTERCOM_BTN = { css: '.intercom-launcher' }
  CLOSE_INTERCOM_BTN = INTERCOM_BTN
  PENDING_CONSENT_BTN = { css: '#incoming-pending-consent-tab' }
  SENT_PENDING_CONSENT_BTN = { css: '#referred-out-pending-consent-tab' }

  def go_to_pending_consent
    click(PENDING_CONSENT_BTN) if is_displayed?(PENDING_CONSENT_BTN)
  end

  def go_to_sent_pending_consent
    click(SENT_PENDING_CONSENT_BTN)
  end

  def page_displayed?
    is_displayed?(NEW_REFERRAL_BTN) &&
    is_displayed?(TIMELINE) &&
    is_not_displayed?(TIMELINE_LOADING)
  end
end

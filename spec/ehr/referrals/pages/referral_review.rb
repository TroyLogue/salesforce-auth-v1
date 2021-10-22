# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ReferralReview < BasePage
  COMPLETE_BTN = { css: '#next-btn' }
  REFERRAL_CARD = { css: '.description-card' }
  REVIEW_TEXT = { xpath: './/div[text()="Review information and complete"]' }

  def page_displayed?
    is_displayed?(REVIEW_TEXT) &&
      is_displayed?(REFERRAL_CARD) &&
      is_displayed?(COMPLETE_BTN)
  end

  def complete_referral
    click(COMPLETE_BTN)
  end
end

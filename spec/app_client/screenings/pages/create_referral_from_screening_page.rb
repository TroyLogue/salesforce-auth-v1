# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CreateReferralFromScreeningPage < BasePage
  STEPPER_CONTENT = { css: '.screening-to-referral' }.freeze

  def page_displayed?
    is_displayed?(STEPPER_CONTENT)
  end
end

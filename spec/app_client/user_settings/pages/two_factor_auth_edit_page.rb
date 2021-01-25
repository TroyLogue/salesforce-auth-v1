# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class TwoFactorAuthEditPage < BasePage
    CANCEL_LINK = { css: '.cancel-link' }.freeze
    FLASH_ALERT = { css: '.flash_alert' }.freeze
    OTP_INPUT = { name: 'two_factor_registration[code]' }.freeze
    RESEND_CODE_LINK = { css: 'a[href="/users/two_factor_registration/resend"]' }.freeze
    SUBMIT_BUTTON = { css: "input[value='Submit']" }.freeze

    INVALID_OTP = '123'
    MESSAGE_OTP_INCORRECT = 'That passcode was not correct. Please try again.'

    def page_displayed?
      is_displayed?(OTP_INPUT) &&
        is_displayed?(SUBMIT_BUTTON) &&
        is_displayed?(CANCEL_LINK)
    end

    def click_cancel
      click(CANCEL_LINK)
    end

    def submit_one_time_password(code:)
      enter(code, OTP_INPUT)
      click(SUBMIT_BUTTON)
    end

    def resend_code_link_displayed?
      is_displayed?(RESEND_CODE_LINK)
    end

    def flash_alert_text
      text(FLASH_ALERT)
    end
  end
end

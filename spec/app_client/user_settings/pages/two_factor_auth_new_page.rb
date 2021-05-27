# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module UserSettings
  class TwoFactorAuthNewPage < BasePage
    CANCEL_LINK = { css: '.cancel-link' }.freeze
    PHONE_NUMBER_INPUT = { name: 'two_factor_registration[phone_number]' }.freeze
    SEND_CODE_BUTTON = { css: "input[value='Send Code']" }.freeze

    # For the purposes of this blackbox test we can use any U.S. phone number;
    # For integration tests with Twilio, see references to their magic numbers:
    # https://www.twilio.com/blog/2018/04/twilio-test-credentials-magic-numbers.html
    # https://www.twilio.com/docs/iam/test-credentials
    VALID_TEST_PHONE_NUMBER = '5005550006'

    def page_displayed?
      is_displayed?(PHONE_NUMBER_INPUT) &&
        is_displayed?(SEND_CODE_BUTTON) &&
        is_displayed?(CANCEL_LINK)
    end

    def submit_phone_number(number:)
      enter(number, PHONE_NUMBER_INPUT)
      click(SEND_CODE_BUTTON)
    end
  end
end

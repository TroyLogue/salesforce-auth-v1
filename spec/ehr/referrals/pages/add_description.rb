# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class AddDescription < BasePage
  MAIN_CONTAINER = { css: '.description-card' }
  NEW_REFERRAL_HEADER = { css: 'h1.referral-name' }
  BACK_BUTTON = { css: '#go-back-page-btn' }
  NEXT_BUTTON = { css: '#next-btn' }
  PROGRAM_NAME = { css: '.description-card > div:nth-child(1) > div > div > p:nth-child(2)' }
  PROVIDER_NAME = { css: '.description-card > div:nth-child(1) > div > div > p:nth-child(3)' }
  SERVICE_TYPE = { css: '.description-card > div:nth-child(2) > div > div > span' }
  PII_WARNING = { css: '.info-panel .info-panel__text' }
  DESCRIPTION_INPUT = { css: '[id^="description-"]' }

  def page_displayed?
    is_displayed(NEW_REFERRAL_HEADER) &&
      is_displayed?(MAIN_CONTAINER) &&
      is_displayed?(BACK_BUTTON) &&
      is_displayed?(NEXT_BUTTON) &&
      is_displayed?(PROGRAM_NAME) &&
      is_displayed?(PROVIDER_NAME) &&
      is_displayed?(SERVICE_TYPE) &&
      is_displayed?(PII_WARNING) &&
      is_displayed?(DESCRIPTION_INPUT)
  end

  def enter_description(description:)
    enter(DESCRIPTION_INPUT, description)
  end

  def program_name
    text(PROGRAM_NAME)
  end

  def provider_name
    text(PROVIDER_NAME)
  end

  def click_next
    click(NEXT_BUTTON)
  end
end

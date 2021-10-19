# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class AddDescription < BasePage
  NEW_REFERRAL_HEADER = { css: 'h1.referral-name' }
  BACK_BUTTON = { css: '#go-back-page-btn' }
  NEXT_BUTTON = { css: '#next-btn' }
  PRIMARY_WORKER_SELECT_FIELD = { css: '.ui-text-field + .flex > div > div.ui-select-field' }
  PRIMARY_WORKER_OPTION = { css: '.is-open div[id^="choices-primary-worker-"]'}
  PROGRAM_NAME = { css: '.description-card > div:nth-child(1) > div > div > p:nth-child(2)' }
  PROVIDER_NAME = { css: '.description-card > div:nth-child(1) > div > div > p:nth-child(3)' }
  REFERRAL_CARD = { css: '.description-card' }
  SERVICE_TYPE = { css: '.description-card > div:nth-child(2) > div > div > span' }
  PII_WARNING = { css: '.info-panel .info-panel__text' }
  DESCRIPTION_INPUT = { css: '[id^="description-"]' }

  def page_displayed?
    is_displayed?(NEW_REFERRAL_HEADER) &&
      is_displayed?(REFERRAL_CARD) &&
      is_displayed?(BACK_BUTTON) &&
      is_displayed?(NEXT_BUTTON) &&
      is_displayed?(PROGRAM_NAME) &&
      is_displayed?(PROVIDER_NAME) &&
      is_displayed?(SERVICE_TYPE) &&
      is_displayed?(PII_WARNING) &&
      is_displayed?(DESCRIPTION_INPUT)
  end

  def fill_out_description_card_for_each_referral(description:)
    referral_cards = find_elements(REFERRAL_CARD)
    referral_cards.each do |referral_card|
      enter_within(description, referral_card, DESCRIPTION_INPUT)
      primary_worker_dropdown = referral_card.find_element(PRIMARY_WORKER_SELECT_FIELD)
      if primary_worker_dropdown
        click(primary_worker_dropdown)
        click_random(PRIMARY_WORKER_OPTION)
      end
    end
  end

  def click_next
    click(NEXT_BUTTON)
  end
end

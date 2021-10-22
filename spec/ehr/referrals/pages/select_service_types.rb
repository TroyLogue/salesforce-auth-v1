# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class SelectServiceTypes < BasePage
  BACK_BUTTON = { css: '#go-back-page-btn' }
  NEXT_BUTTON = { css: '#next-btn' }
  REFERRAL_CARD = { css: '.program-services' }
  REMOVE_BUTTON = { css: 'button[data-qa=remove-btn]' }
  SERVICE_TYPE_HEADER = { xpath: '//p[text()="What is the client’s primary need?"]' }
  SERVICE_TYPE_OPTIONS = { css: '.ui-radio-field__item' }

  def page_displayed?
    is_displayed?(REFERRAL_CARD) &&
      is_displayed?(BACK_BUTTON) &&
      is_displayed?(SERVICE_TYPE_HEADER) &&
      is_displayed?(REMOVE_BUTTON) &&
      is_displayed?(NEXT_BUTTON)
  end

  def number_of_referrals_displayed
    find_elements(REFERRAL_CARD).length
  end

  def click_next
    click(NEXT_BUTTON)
  end

  def select_random_service_type_for_each_referral
    referral_cards = find_elements(REFERRAL_CARD)
    referral_cards.each do |referral_card|
      service_types = referral_card.find_elements(SERVICE_TYPE_OPTIONS)
      service_types.sample.click
    end
  end
end

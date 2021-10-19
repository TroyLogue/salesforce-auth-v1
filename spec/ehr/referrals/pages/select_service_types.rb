# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class SelectServiceTypes < BasePage
  BACK_BUTTON = { css: '#go-back-page-btn' }
  NEXT_BUTTON = { css: '#next-btn' }
  PROGRAM_CARD = { css: '.program-services' }
  REMOVE_BUTTON = { css: 'button[data-qa=remove-btn]' }
  SERVICE_TYPE_HEADER = { xpath: '//p[text()="What is the client’s primary need?"]' }
  SERVICE_TYPE_OPTIONS = { css: '.program-services .ui-radio-field__item' }

  def page_displayed?
    is_displayed?(PROGRAM_CARD) &&
      is_displayed?(BACK_BUTTON) &&
      is_displayed?(SERVICE_TYPE_HEADER) &&
      is_displayed?(REMOVE_BUTTON) &&
      is_displayed?(NEXT_BUTTON)
  end

  def click_next
    click(NEXT_BUTTON)
  end
end

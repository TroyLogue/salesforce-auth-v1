# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningsTable < BasePage
  CREATE_SCREENING_BTN = { css: 'button[aria-label="New Screening"]' }
  LOADING_SCREENINGS = { xpath: './/span[text()="Loading..."]' }
  SPINNER = { css: '.loader' }

  def page_displayed?
    is_displayed?(CREATE_SCREENING_BTN) &&
      wait_for_spinner(SPINNER)
  end

  def create_screening
    click(CREATE_SCREENING_BTN)
  end
end

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningsTable < BasePage
  CREATE_SCREENING_BTN = { css: '#create-screening-btn' }
  LOADING_SCREENINGS = { xpath: './/p[text()="Loading Screenings..."]' }


  def page_displayed?
    is_displayed?(CREATE_SCREENING_BTN)
    is_not_displayed?(LOADING_SCREENINGS)
  end

  def create_screening
    click(CREATE_SCREENING_BTN)
  end
end

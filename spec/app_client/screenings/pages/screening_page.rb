# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningPage < BasePage
  SCREENING_DETAIL = { class: 'screening-detail' }
  NO_NEEDS_DISPLAY = { css: '.risk-display__no-needs' }
  IDENTIFIED_SERVICE_CARD_TITLES = { css: '.risk-display .ui-base-card .ui-base-card-header__title' }
  IDENTIFIED_SERVICE_CARDS = { css: '.risk-display .ui-base-card' }

  def page_displayed?
    is_displayed?(SCREENING_DETAIL)
    wait_for_spinner
  end

  def no_needs_displayed?
    is_displayed?(NO_NEEDS_DISPLAY)
  end
end
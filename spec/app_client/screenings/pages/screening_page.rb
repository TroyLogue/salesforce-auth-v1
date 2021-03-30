# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningPage < BasePage
  SCREENING_DETAIL = { class: 'screening-detail' }
  EDIT_SCREENING_BTN = { css: '#edit-screening-btn' }
  NO_NEEDS_DISPLAY = { css: '.risk-display__no-needs' }
  IDENTIFIED_SERVICE_CARD_TITLES = { css: '.risk-display .ui-base-card .ui-base-card-header__title' }
  IDENTIFIED_SERVICE_CARDS = { css: '.risk-display .ui-base-card' }
  SUBMIT_BTN = { css: '#submit-btn' }
  SUBMIT_BTN_DISABLED = { css: '#submit-btn.ui-button--disabled' }

  def page_displayed?
    is_displayed?(SCREENING_DETAIL) &&
    wait_for_spinner
  end

  def edit_screening
    click(EDIT_SCREENING_BTN)
    is_displayed?(SUBMIT_BTN)
  end

  def no_needs_displayed?
    is_displayed?(NO_NEEDS_DISPLAY)
  end

  def submit_screening
    click(SUBMIT_BTN)
    wait_for_spinner(SUBMIT_BTN_DISABLED)
  end
end

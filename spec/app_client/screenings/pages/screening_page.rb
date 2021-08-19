# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningPage < BasePage
  SCREENING_DETAIL = { class: 'screening-detail' }.freeze

  # detail form
  EDIT_SCREENING_BTN = { css: '#edit-screening-btn' }.freeze
  SUBMIT_BTN = { css: '#submit-btn' }.freeze
  SUBMIT_BTN_DISABLED = { css: '#submit-btn.ui-button--disabled' }.freeze

  # needs card
  NO_NEEDS_DISPLAY = { css: '.risk-display__no-needs' }.freeze
  SCREENING_NEEDS_SELECTOR = { css: '.screening-need-selector' }.freeze
  IDENTIFIED_SERVICE_CARD_TITLES = { css: '.risk-display .ui-base-card .ui-base-card-header__title' }.freeze
  IDENTIFIED_SERVICE_CARDS = { css: '.risk-display .ui-base-card' }.freeze
  SERVICE_TYPE_CHECKBOX = { css: '.screening-need-selector__body input[type="checkbox"]' }.freeze
  SERVICE_TYPE_CHECKBOX_LABEL = { css: '.screening-need-selector__body .ui-checkbox-field .ui-form-field__label' }.freeze
  CREATE_REFERRALS_BUTTON = { css: '#screening-need-selector-submit-button' }.freeze

  def page_displayed?
    is_displayed?(SCREENING_DETAIL) &&
      wait_for_spinner
  end

  def click_create_referrals
    click(CREATE_REFERRALS_BUTTON) &&
      wait_for_spinner
  end

  def edit_screening
    click(EDIT_SCREENING_BTN)
    is_displayed?(SUBMIT_BTN)
  end

  def needs_displayed?
    is_displayed?(SCREENING_NEEDS_SELECTOR) &&
      is_displayed?(SERVICE_TYPE_CHECKBOX_LABEL) &&
      is_checked?(SERVICE_TYPE_CHECKBOX) && # checkboxes should be checked by default
      is_displayed?(CREATE_REFERRALS_BUTTON)
  end

  def no_needs_displayed?
    is_displayed?(NO_NEEDS_DISPLAY)
  end

  def selected_needs_count
    checkboxes = find_elements(SERVICE_TYPE_CHECKBOX)
    checkboxes.map { |checkbox| checkbox if checkbox.selected? }.compact.count
  end

  def submit_screening
    click(SUBMIT_BTN)
    is_not_displayed?(SUBMIT_BTN_DISABLED)
  end
end

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Screening < BasePage
  CREATE_REFERRAL_BUTTON_FIRST = { css: '.screening-risk-display .ui-base-card .ui-button' }
  EDIT_BTN = { css: '#screening-edit-btn' }
  IDENTIFIED_SERVICE_CARD = { css: '.screening-risk-display .ui-base-card' }
  IDENTIFIED_SERVICE_CARD_HEADER = { css: '.screening-risk-display .ui-base-card .ui-base-card-header__title' }
  NEEDS_DISPLAY = { css: '.screening-risk-display' }
  NO_NEEDS_DISPLAY = { css: '.screening-risk-display__no-needs' }
  NO_NEEDS_IDENTIFIED_MESSAGE = "No needs were identified for your client."
  SUBMIT_BTN = { css: '#submit-btn' }

  def create_referral_from_identified_need
    click(CREATE_REFERRAL_BUTTON_FIRST)
  end

  def click_edit
    click(EDIT_BTN)
  end

  def click_submit
    click(SUBMIT_BTN)
  end

  def edit_view_displayed?
    is_displayed?(SUBMIT_BTN)
  end

  def get_first_identified_service_type
    text(IDENTIFIED_SERVICE_CARD_HEADER)
  end

  def needs_identified?
    service_type = get_first_identified_service_type
    service_type_message = "This client has been determined to have a #{service_type} need."

    text(IDENTIFIED_SERVICE_CARD).include?(service_type_message)
  end

  def no_needs_identified?
    text(NO_NEEDS_DISPLAY).include?(NO_NEEDS_IDENTIFIED_MESSAGE)
  end

  def page_displayed?
    ( is_displayed?(NEEDS_DISPLAY) || is_displayed?(NO_NEEDS_DISPLAY) ) &&
      is_not_displayed?(SUBMIT_BTN)
  end
end

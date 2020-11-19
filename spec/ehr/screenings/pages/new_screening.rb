# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewScreening < BasePage
  NEW_SCREENING_DIV = { css: '.new-screening' }
  SCREENING_CHOICE = { css: '.choices__item' }
  SCREENING_FORM = { css: '.ui-form-renderer' }
  SELECT_SCREENING_DROPDOWN = { css: '.screening-form-select .choices' }
  SUBMIT_SCREENING_BTN = { css: '#submit-screening-btn' }

  # specific to this screening:
  SCREENING_NAME = "Food and Housing Screening"
  # answering yes will bring up referral needs
  RADIO_BTN = { css: '.ui-radio-field__item span' }

  def complete_screening_with_referral_needs
    select_screening(SCREENING_NAME)
    click_element_by_text(RADIO_BTN, "Yes")
    submit_screening
  end

  def complete_screening_with_no_referral_needs
    select_screening(SCREENING_NAME)
    click_element_by_text(RADIO_BTN, "No")
    submit_screening
  end

  def page_displayed?
    is_displayed?(NEW_SCREENING_DIV) &&
      is_displayed?(SELECT_SCREENING_DROPDOWN)
  end

  def select_screening(screening_name)
    click(SELECT_SCREENING_DROPDOWN)
    click_element_by_text(SCREENING_CHOICE, screening_name)
    is_displayed?(SCREENING_FORM)
  end

  def submit_screening
    click(SUBMIT_SCREENING_BTN)
  end
end

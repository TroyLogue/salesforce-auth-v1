require_relative '../../../shared_components/base_page'

class FacesheetAssessment < BasePage
  ASSESSMENT = { css: '.assessments-show' }
  ASSESSMENT_BODY = { css: '.assessments-show .ui-base-card-body' }
  ASSESSMENT_HEADER = { css: '.ui-base-card-header__title' }
  BACK_BUTTON = { css: '.back-button button' }
  EDIT_BUTTON = { css: '#assessment-edit-btn' }
  SAVE_BUTTON = { css: '#save-btn' }
  CANCEL_BUTTON = { css: '#cancel-btn' }

  #data for UI-Tests No Rules
  NOT_FILLED_OUT_TEXT = "Text Fields\nOne Line Input Question\nMulti Line Text Question\nThank you for completing the screening. Someone will be in touch with you if any needs were identified.\nEmail question\nSelect Fields\nDrop Down Question\nRadio Input\nCheckbox Question\nNumber Fields\nInteger and Decimals Question\nDate Question\nDuration Question"

  #UI-Tests No Rules fields:
  SINGLE_LINE_INPUT_FIELD = { xpath: '//div[@class="ui-form-renderer-question"][1]//input' }
  MULTI_LINE_INPUT_FIELD = { xpath: '//div[@class="ui-form-renderer-question"][2]//textarea' }
  # The third item is 'Thank you for filling out assessment' text - no questions
  EMAIL_INPUT_FIELD = { xpath: '//div[@class="ui-form-renderer-question"][4]//input' }
  DROPDOWN_MENU = { css: '.ui-form-renderer-question .ui-select-field .choices' }
  DROPDOWN_OPTION_FIRST = { css: '.ui-form-renderer-question .ui-select-field .choices__item--selectable' }
  RADIO_BUTTON_FIRST = { css: '.ui-form-renderer-question .ui-radio-field__item' }
  CHECKBOX_FIRST = { css: '.ui-form-checkbox-group .ui-checkbox-field label' }
  NUMBER_INPUT_FIELD = { css: '.ui-form-renderer-question .ui-input-field input[type=number]' }
  DATE_INPUT_FIELD = { css: '.ui-form-renderer-question .ui-date-field input[type=text]' }

  def page_displayed?
    is_displayed?(ASSESSMENT) &&
    is_displayed?(ASSESSMENT_BODY) &&
    is_displayed?(EDIT_BUTTON) &&
    is_not_displayed?(SAVE_BUTTON)
  end

  def assessment_text
    text(ASSESSMENT_BODY)
  end

  def click_edit_button
    click(EDIT_BUTTON)
  end

  def edit_view_displayed?
    is_displayed?(ASSESSMENT) &&
    is_not_displayed?(EDIT_BUTTON) &&
    is_displayed?(CANCEL_BUTTON) &&
    is_displayed?(SAVE_BUTTON)
  end

  #TODO UU3-20560 include duration fields when bug is fixed
  def fill_out_form(single_line_text:, multi_line_text:, email:, number:, date:)
    clear_then_enter(single_line_text, SINGLE_LINE_INPUT_FIELD)
    clear_then_enter(multi_line_text, MULTI_LINE_INPUT_FIELD)
    clear_then_enter(email, EMAIL_INPUT_FIELD)
    click(DROPDOWN_MENU)
    click(DROPDOWN_OPTION_FIRST)
    click(RADIO_BUTTON_FIRST)
    click(CHECKBOX_FIRST)
    clear_then_enter(number, NUMBER_INPUT_FIELD)
    clear_then_enter(date, DATE_INPUT_FIELD)
  end

  def is_not_filled_out?
    assessment_text.eql?(NOT_FILLED_OUT_TEXT)
  end

  def header_text
    text(ASSESSMENT_HEADER)
  end

  def save
    click(SAVE_BUTTON)
  end
end

require_relative '../../../shared_components/base_page'

class Assessment < BasePage
  ASSESSMENT = { css: '.assessments-show' }
  ASSESSMENT_BODY = { css: '.ui-form-renderer form' }
  ASSESSMENT_HEADER = { css: '.ui-base-card-header__title' }
  BACK_BUTTON = { css: '.back-button button' }
  EDIT_BUTTON = { css: '#assessment-edit-btn' }
  SAVE_BUTTON = { css: '#save-btn' }
  CANCEL_BUTTON = { css: '#cancel-btn' }

  #data for UI-Tests No Rules
  NOT_FILLED_OUT_TEXT = "Text Fields\nOne Line Input Question\nMulti Line Text Question\nThank you for completing the screening. Someone will be in touch with you if any needs were identified.\nEmail question\nSelect Fields\nDrop Down Question\nRadio Input\nCheckbox Question\nNumber Fields\nInteger and Decimals Question\nDate Question\nDuration Question"

  def page_displayed?
    is_displayed?(ASSESSMENT) &&
    is_displayed?(ASSESSMENT_BODY)
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

  def is_not_filled_out?
    assessment_text.eql?(NOT_FILLED_OUT_TEXT)
  end

  def header_text
    text(ASSESSMENT_HEADER)
  end
end

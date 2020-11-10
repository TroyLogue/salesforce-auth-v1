# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Assessment < BasePage
  ASSESSMENT_CARD = { css: '.assessments-show .ui-base-card' }
  ASSESSMENT_TITLE = { css: '.ui-base-card-header__title' }
  EDIT_BTN = { css: '#assessment-edit-btn' }
  FIRST_RESPONSE_VALUE = { css: '.ui-form-renderer-question-display__value' }
  INPUT_FIELD = { css: 'input[type="text"]' }
  SAVE_BTN = { css: '#save-btn' }

  def assessment_name_displayed?(name)
    text(ASSESSMENT_TITLE).include?(name)
  end

  def edit_assessment(value)
    click(EDIT_BTN)
    clear_then_enter(value, INPUT_FIELD)
    click(SAVE_BTN)
  end

  def first_response_text
    text(FIRST_RESPONSE_VALUE)
  end

  def page_displayed?(assessment_name: '')
    is_displayed?(ASSESSMENT_CARD) &&
      is_displayed?(EDIT_BTN) &&
      assessment_name_displayed?(assessment_name)
  end
end

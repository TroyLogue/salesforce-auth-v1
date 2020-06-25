require_relative '../../../shared_components/base_page'

class Assessment < BasePage
  ASSESSMENT = { css: '.assessment-details-view' }
  ASSESSMENT_BODY = { css: '.ui-base-card-body' }
  ASSESSMENT_HEADER = { css: '.ui-base-card-header__title' }
  BACK_BUTTON = { css: '.back-button button' }
  EDIT_BUTTON = { css: '#edit-assessment-btn' }
  SAVE_BUTTON = { css: '#save-btn' }
  CANCEL_BUTTON = { css: '#cancel-btn' }

  #fields for Ivy League Intake Form
  IVY_INTAKE_NOT_FILLED_OUT_TEXT = "School section\nWhat is your school?\nLocation section\nWhere is the school located?"
  IVY_INTAKE_INPUT_FIRST = { xpath: '//div[@class="ui-form-renderer-question"][1]//input' }
  IVY_INTAKE_INPUT_SECOND = { xpath: '//div[@class="ui-form-renderer-question"][2]//input' }

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

  def fill_out_form(question_one:, question_two:)
    clear_then_enter(question_one, IVY_INTAKE_INPUT_FIRST)
    clear_then_enter(question_two, IVY_INTAKE_INPUT_SECOND)
  end

  def is_not_filled_out?
    assessment_text.eql?(IVY_INTAKE_NOT_FILLED_OUT_TEXT)
  end

  def header_text
    text(ASSESSMENT_HEADER)
  end

  def save
    click(SAVE_BUTTON)
  end

end

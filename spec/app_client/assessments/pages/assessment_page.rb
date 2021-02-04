require_relative '../../../shared_components/base_page'

class Assessment < BasePage
  ASSESSMENT = { css: '.assessments-show' }
  ASSESSMENT_BODY = { css: '.assessments-show .ui-base-card-body' }
  ASSESSMENT_HEADER = { css: '.ui-base-card-header__title' }
  BACK_BUTTON = { css: '.back-button button' }
  EDIT_BUTTON = { css: '#assessment-edit-btn' }
  SAVE_BUTTON = { css: '#save-btn' }
  CANCEL_BUTTON = { css: '#cancel-btn' }

  #Military Information view:
  MILITARY_INFORMATION_CONTAINER = { css: 'section[data-role="military-information"]' }
  EDIT_MILITARY_BTN = { css: '#edit-military-btn' }

  #Ivy League Intake Form fields:
  IVY_LEAGUE_INTAKE_FORM = "Ivy League Intake Form"
  IVY_INTAKE_NOT_FILLED_OUT_TEXT = "School section\nWhat is your school?\nLocation section\nWhere is the school located?"
  IVY_INTAKE_INPUT_FIRST = { xpath: '(//div[@class="ui-form-renderer-question"]//input)[1]' }
  IVY_INTAKE_INPUT_SECOND = { xpath: '(//div[@class="ui-form-renderer-question"]//input)[2]' }

  def page_displayed?
    is_displayed?(ASSESSMENT) &&
    is_displayed?(ASSESSMENT_BODY) &&
    is_displayed?(EDIT_BUTTON) &&
    is_not_displayed?(SAVE_BUTTON)
  end

  def assessment_text
    text(ASSESSMENT_BODY)
  end

  def click_back_button
    click(BACK_BUTTON)
  end

  def click_edit_button
    click(EDIT_BUTTON)
  end

  def edit_and_save(responses:)
    click_edit_button
    fill_out_form(question_one: responses[0], question_two: responses[1])
    save
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

  def military_information_page_displayed?
    is_displayed?(MILITARY_INFORMATION_CONTAINER) &&
    is_displayed?(EDIT_MILITARY_BTN)
  end

  def save
    click(SAVE_BUTTON)
  end
end

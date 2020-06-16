require_relative '../../../shared_components/base_page'

class Assessment < BasePage
  ASSESSMENT = { css: '.assessments-show' }
  ASSESSMENT_HEADER = { css: '.ui-base-card-header__title' }
  BACK_BUTTON = { css: '.back-button button' }
  EDIT_BUTTON = { css: '#assessment-edit-btn' }
  SAVE_BUTTON = { css: '#save-btn' }
  CANCEL_BUTTON = { css: '#cancel-btn' }

  def page_displayed?
    is_displayed?(ASSESSMENT) &&
    wait_for_spinner
  end

  def edit_view_displayed?
    is_displayed(ASSESSMENT) &&
    is_not_displayed(EDIT_BUTTON) &&
    is_displayed(CANCEL_BUTTON) &&
    is_displayed(SAVE_BUTTON)
  end

  def header_text
    text(ASSESSMENT_HEADER)
  end

  def click_edit_button
    click(EDIT_BUTTON)
  end
end

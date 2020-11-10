# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class AssessmentPage < BasePage
  ASSESSMENT_CARD = { css: '.assessments-show .ui-base-card' }
  ASSESSMENT_TITLE = { css: '.ui-base-card-header__title' }
  EDIT_BTN = { css: '#assessment-edit-btn' }

  def assessment_name_displayed?(name)
    text(ASSESSMENT_TITLE).include?(name)
  end

  def page_displayed?(assessment_name: '')
    is_displayed?(ASSESSMENT_CARD) &&
      is_displayed?(EDIT_BTN) &&
      assessment_name_displayed?(assessment_name)
  end

end

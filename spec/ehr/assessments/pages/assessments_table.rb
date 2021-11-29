# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class AssessmentsTable < BasePage
  ASSESSMENT = { css: '.table-component tr td' }
  ASSESSMENTS_HEADER = { xpath:'.//span[text()="Assessments"]' }
  LOADING_ASSESSMENTS = { xpath: './/span[text()="Loading..."]' }
  TABLE = { css: '.table-component' }

  def open_assessment_by_name(assessment_name)
    is_not_displayed?(LOADING_ASSESSMENTS)
    click_element_from_list_by_text(ASSESSMENT, assessment_name)
  end

  def page_displayed?
    is_displayed?(TABLE) &&
      is_displayed?(ASSESSMENTS_HEADER)
  end
end

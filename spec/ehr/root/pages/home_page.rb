require_relative '../../../shared_components/base_page'

class HomePage < BasePage
  ASSESSMENTS_SECTION = { css: '.assessment-forms' }
  ASSESSMENT = { css: '.assessment-forms .ui-table-row-column' }
  CASES_SECTION = { css: '.cases' }
  LOADING_ASSESSMENTS = { xpath: './/p[text()="Loading Assessments..."]' }
  NAVBAR = { css: '.navigation' }
  SCREENINGS_SECTION = { css: '.screenings' }


  def open_assessment_by_name(assessment_name)
    is_not_displayed?(LOADING_ASSESSMENTS)
    click_element_from_list_by_text(ASSESSMENT, assessment_name)
  end

  def page_displayed?
    is_displayed?(NAVBAR) &&
      is_displayed?(CASES_SECTION) &&
      is_displayed?(ASSESSMENTS_SECTION) &&
      is_displayed?(SCREENINGS_SECTION)
  end
end

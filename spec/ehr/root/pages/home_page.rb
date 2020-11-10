require_relative '../../../shared_components/base_page'

class HomePage < BasePage
  ASSESSMENTS_SECTION = { css: '.assessment-forms' }
  CASES_SECTION = { css: '.cases' }
  NAVBAR = { css: '.navigation' }
  SCREENINGS_SECTION = { css: '.screenings' }


  def page_displayed?
    is_displayed?(NAVBAR) &&
      is_displayed?(CASES_SECTION) &&
      is_displayed?(ASSESSMENTS_SECTION) &&
      is_displayed?(SCREENINGS_SECTION)
  end
end

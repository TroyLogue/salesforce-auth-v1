require_relative '../../../shared_components/base_page'

class SearchClient < BasePage
  FIRSTNAME_INPUT = { css: '#first-name' }
  LASTNAME_INPUT = { css: '#last-name' }
  DOB_INPUT = { css: '#date-of-birth' }
  SEARCH_BTN = { css: '#search-records-btn' }

  def page_displayed?
    is_displayed(FIRSTNAME_INPUT) &&
    is_displayed?(LASTNAME_INPUT) &&
    is_displayed?(DOB)
  end

  def search_client(fname:, lname:, dob:)
    enter(fname, FIRSTNAME_INPUT)
    enter(lname, LASTNAME_INPUT)
    enter(dob, DOB_INPUT)
    click(SEARCH_BTN)
  end
end

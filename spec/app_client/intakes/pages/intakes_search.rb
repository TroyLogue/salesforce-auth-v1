# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class IntakesSearch < BasePage
  CREATE_INTAKE = { css: '.intakes-search-view' }.freeze
  FIRSTNAME_INPUT = { css: '#first-name' }.freeze
  LASTNAME_INPUT = { css: '#last-name' }.freeze
  DOB_INPUT = { css: '#date-of-birth' }.freeze
  SEARCH_OUR_RECORDS_BTN = { id: 'search-records-btn' }.freeze

  def page_displayed?
    is_displayed?(CREATE_INTAKE)
  end

  def input_first_name(fname)
    enter(fname, FIRSTNAME_INPUT)
  end

  def input_last_name(lname)
    enter(lname, LASTNAME_INPUT)
  end

  def input_dob(date_of_birth)
    enter(date_of_birth, DOB_INPUT)
  end

  def input_present?
    text(FIRSTNAME_INPUT) &&
      text(LASTNAME_INPUT) &&
      text(DOB_INPUT)
  end

  def search_records
    click(SEARCH_OUR_RECORDS_BTN)
  end
end

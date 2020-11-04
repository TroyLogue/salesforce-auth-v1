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

  def input_fname_lname_dob(fname, lname, date_of_birth)
    enter(fname, FIRSTNAME_INPUT)
    enter(lname, LASTNAME_INPUT)
    enter(date_of_birth, DOB_INPUT)
  end

  def is_info_prefilled?(**params)
    if params.key?(:fname) && value(FIRSTNAME_INPUT) != params[:fname]
      print "First Name value saved '#{params[:fname]}' do not equal value displayed '#{value(FIRSTNAME_INPUT)}'"
      return false
    end
    if params.key?(:lname) && value(LASTNAME_INPUT) != params[:lname]
      print "Last Name value saved '#{params[:fname]}' do not equal value displayed '#{value(LASTNAME_INPUT)}'"
      return false
    end
    if params.key?(:dob) && value(DOB_INPUT) != params[:dob]
      print "Dob value saved '#{params[:dob]}' do not equal value displayed '#{value(DOB_INPUT)}'"
      return false
    end
    true
  end

  def search_records
    click(SEARCH_OUR_RECORDS_BTN)
  end
end

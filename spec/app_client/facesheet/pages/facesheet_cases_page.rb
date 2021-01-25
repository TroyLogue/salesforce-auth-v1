# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FacesheetCases < BasePage
  BTN_CREATE_NEW_CASE = { css: '#create-new-case-btn' }.freeze
  FACESHEET_CASES = { css: '.facesheet-cases' }.freeze
  FIRST_CASE_ROW = { css: 'tr[id^=case-row]:nth-of-type(1) td' }.freeze

  def page_displayed?
    wait_for_spinner
    is_displayed?(FACESHEET_CASES)
  end

  def click_first_case
    page_displayed?
    click(FIRST_CASE_ROW)
  end

  def create_new_case
    click(BTN_CREATE_NEW_CASE)
    wait_for_spinner
  end
end

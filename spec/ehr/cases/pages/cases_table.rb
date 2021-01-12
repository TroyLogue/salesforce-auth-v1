# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CasesTable < BasePage
  HEADER = { css: '.cases .header-title__text' }

  TABLE_MESSAGE = { css: '.cases .ui-expandable__body > .message' }
  LOADING_CASES_MESSAGE_TEXT = 'Loading Cases'
  NO_CASES_MESSAGE_TEXT = 'No cases to display'

  TABLE_ROW = { css: '.cases-table .ui-table-body .ui-table-row' }

  def table_displayed?
    is_displayed?(HEADER)
  end

  def click_first_case
    loading_cases_complete? && cases[0].click
  end

  def loading_cases_complete?
    # if results are returned then TABLE_MESSAGE will not be displayed
    if is_not_displayed?(TABLE_MESSAGE)
      true
    # if no results are returned then TABLE_MESSAGE will be displayed but LOADING_CASES_MESSAGE_TEXT will not
    elsif find_element_by_text(TABLE_MESSAGE, LOADING_CASES_MESSAGE_TEXT).nil?
      true
    # if neither of the above conditions are met then cases are not loaded
    else
      puts "Cases have not finished loading"
      false
    end
  end

  def no_cases_message_displayed?
    true if is_displayed?(TABLE_MESSAGE, 1) && text(TABLE_MESSAGE) == NO_CASES_MESSAGE_TEXT
  end

  def cases_displayed?
    is_displayed?(TABLE_ROW, 1)
  end

  private
  def cases
    find_elements(TABLE_ROW)
  end
end

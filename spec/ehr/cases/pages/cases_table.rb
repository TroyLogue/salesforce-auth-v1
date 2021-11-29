# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CasesTable < BasePage
  EXTERNAL_CASES_TAB = { css: '#cases-header2-btn' }
  HEADER = { css: '.patient-table-header' }
  INTERNAL_CASES_TAB = { css: '#cases-header1-btn' }
  LOADING_CASES_MESSAGE_TEXT = 'Loading...'
  MORE_FILTERS_BTN = { xpath: '//span[text()="Filters"]' }
  NO_CASES_MESSAGE_TEXT = 'No cases here.'
  PRIMARY_WORKER_FILTER = { css: '#primary-worker-filter' }
  STATUS_FILTER = { css: '#status-filter' }
  TABLE_BODY = { css: '.table-component' }
  TABLE_MESSAGE = { css: '.table-component td.text-center' }
  TABLE_ROW = { xpath: '//table/tbody/tr' }

  def page_displayed?
    is_displayed?(HEADER) &&
      is_displayed?(INTERNAL_CASES_TAB) &&
      is_displayed?(EXTERNAL_CASES_TAB) &&
      is_displayed?(STATUS_FILTER) &&
      is_displayed?(PRIMARY_WORKER_FILTER) &&
      is_displayed?(MORE_FILTERS_BTN) &&
      is_displayed?(TABLE_BODY)
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

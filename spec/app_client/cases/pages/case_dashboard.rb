require_relative '../../../shared_components/base_page'

module CaseDashboard
  module SharedComponents
    CARE_COORDINATOR_DROPDOWN = { css: '#care-coordinator-filter' }.freeze
    CARE_COORDINATOR_SEARCH = { css: '#care-coordinator-filter .ui-filter-search > input' }.freeze
    CARE_COORDINATOR_FIRST_OPTION = { css: '#care-coordinator-filter .filter-options__container div:nth-of-type(2)' }.freeze
    CARE_COORDINATOR_SELECTED_OPTION = { css: "#{CARE_COORDINATOR_FIRST_OPTION[:css]} label" }.freeze

    PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker-filter' }.freeze
    PRIMARY_WORKER_SEARCH = { css: '#primary-worker-filter .ui-filter-search > input' }.freeze
    PRIMARY_WORKER_FIRST_OPTION = { css: '#primary-worker-filter .filter-options__container div:nth-of-type(2)' }.freeze
    PRIMARY_WORKER_SELECTED_OPTION = { css: "#{PRIMARY_WORKER_FIRST_OPTION[:css]} label" }.freeze

    def search_and_select_first_care_coordinator(text)
      click(CARE_COORDINATOR_DROPDOWN)
      clear_then_enter(text, CARE_COORDINATOR_SEARCH)
      is_displayed?(CARE_COORDINATOR_FIRST_OPTION)
      selected_option_text = text(CARE_COORDINATOR_SELECTED_OPTION)
      click(CARE_COORDINATOR_FIRST_OPTION)
      click(CARE_COORDINATOR_DROPDOWN)
      selected_option_text
    end

    def search_and_select_first_primary_worker(text)
      click(PRIMARY_WORKER_DROPDOWN)
      clear_then_enter(text, PRIMARY_WORKER_SEARCH)
      is_displayed?(PRIMARY_WORKER_FIRST_OPTION)
      selected_option_text = text(PRIMARY_WORKER_SELECTED_OPTION)
      click(PRIMARY_WORKER_FIRST_OPTION)
      click(PRIMARY_WORKER_DROPDOWN)
      selected_option_text
    end
  end

  class Open < BasePage
    include SharedComponents

    CARE_COORDINATOR_LIST = { css: '#open-cases-table > .ui-table > .ui-table-body > tbody > tr > td:nth-of-type(5)' }.freeze
    NO_CASES_TEXT_CONTAINER = { css: '#open-cases-table .dashboard-inner-content > div > div > h3' }.freeze
    NO_CASES_TEXT = 'There are no open cases.'
    OPEN_CASES_TABLE = { css: '.dashboard-content #open-cases-table' }.freeze
    PRIMARY_WORKER_LIST = { css: '#open-cases-table > .ui-table > .ui-table-body > tbody > tr > td:nth-of-type(5)' }.freeze

    def open_cases_table_displayed?
      is_displayed?(OPEN_CASES_TABLE)
    end

    def go_to_open_cases_dashboard
      get('/dashboard/cases/open')
    end

    def no_cases_message_displayed?
      is_displayed?(NO_CASES_TEXT_CONTAINER) && text(NO_CASES_TEXT_CONTAINER).eql?(NO_CASES_TEXT)
    end

    def cases_match_primary_worker?(text)
      primary_workers = find_elements(PRIMARY_WORKER_LIST).map(&:text)
      primary_workers.all? {|pm| pm.eql?(text)}
    end

    def cases_match_care_coordinator?(text)
      care_coordinators = find_elements(CARE_COORDINATOR_LIST).map(&:text)
      care_coordinators.all? {|pm| pm.eql?(text)}
    end
  end

  class Closed < BasePage
    include SharedComponents

    CLOSED_CASES_TABLE = { css: '#closed-cases-table' }.freeze

    def page_displayed?
      is_displayed?(CLOSED_CASES_TABLE)
    end
  end
end

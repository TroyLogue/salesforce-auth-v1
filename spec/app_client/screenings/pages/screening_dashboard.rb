# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

module ScreeningDashboard
  class AllScreenings < BasePage
    SCREENINGS_TABLE = { id: 'all-screenings-table' }
    AUTHORIZED_CLIENTS = { css: '.ui-table-body > tr:not(.unauthorized) > td:nth-child(2) > span' }
    CARE_COORDINATOR_FILTER = { id: 'care-coordinator-filter' }
    STATUS_FILTER = { id: 'status-filter' }

    CARE_COORDINATOR_FILTER_TEXT_DEFAULT = 'Care Coordinator'
    STATUS_FILTER_TEXT_DEFAULT = 'Status'

    def page_displayed?
      is_displayed?(SCREENINGS_TABLE) &&
        wait_for_spinner
    end

    def care_coordinator_filter_text
      text(CARE_COORDINATOR_FILTER)
    end

    def status_filter_text
      text(STATUS_FILTER)
    end

    def select_and_click_random_client
      selected_client = find_elements(AUTHORIZED_CLIENTS).sample
      raise StandardError, "E2E ERROR: No elements of Selector AUTHORIZED_CLIENTS were found" unless selected_client
      @selected_client_name = selected_client.text
      selected_client.click
    end

    # client name format is "last, first" in screening table while the screening name header is "first last". this method is to do the conversion
    def selected_client_name
      full_name= @selected_client_name.split(", ")
      full_name[0], full_name[1] = full_name[1], full_name[0]
      full_name.join(" ")
    end
  end

  class ScreeningDetail < BasePage
    NAME_HEADER = { css: '.status-select__full-name.display' }
    GO_TO_FACESHEET_LINK = { class: 'client-name__link' }

    def page_displayed?
      is_displayed?(NAME_HEADER)
    end

    def client_name_header
      text(NAME_HEADER)
    end

    def go_to_facesheet
      click(GO_TO_FACESHEET_LINK)
    end
  end
end

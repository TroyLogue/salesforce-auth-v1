# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FindPrograms < BasePage
  FIND_PROGRAMS_CONTAINER = { css: '.program-select-filter' }
  LOADING_SPINNER = { css: '.loader' }
  MORE_FILTERS_BTN = { css: '#more-filters-btn' }
  # TODO fix this css id - should be next btn not recall btn
  NEXT_BUTTON = { css: '#recall-btn' }
  PROGRAM_CARD = { css: '.network-program-card' }
  SERVICE_TYPE_FILTER = { css: '#service-types-all-filter' }
  SERVICE_TYPE_OPTION = { css: '#service-types-all-filter .ui-filter-option.level-1' }

  def page_displayed?
    is_displayed?(FIND_PROGRAMS_CONTAINER) &&
      is_displayed?(MORE_FILTERS_BTN) &&
      is_displayed?(SERVICE_TYPE_FILTER)
  end

  def click_next
    click(NEXT_BUTTON)
  end

  def select_service_type_by_text(service_type)
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click_element_from_list_by_text(SERVICE_TYPE_OPTION, service_type)
    wait_for_matches
  end

  def select_first_service_type
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FIRST_OPTION)
    wait_for_matches
  end

  def selected_service_type
    text(SERVICE_TYPE_FILTER)
  end

  private

  def wait_for_matches
    is_not_displayed?(LOADING_SPINNER) &&
      is_displayed?(PROGRAM_CARD)
  end
end

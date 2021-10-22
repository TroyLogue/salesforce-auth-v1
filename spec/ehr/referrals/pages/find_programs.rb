# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FindPrograms < BasePage
  FIND_PROGRAMS_CONTAINER = { css: '.program-select-filter' }
  LOADING_SPINNER = { css: '.loader' }
  MORE_FILTERS_BTN = { css: '#more-filters-btn' }
  # TODO fix this css id - should be next btn not recall btn
  NEXT_BUTTON = { css: '#recall-btn' }
  OON_TEXT = "Off-Platform Only"
  PROGRAM_CARD = { css: '.network-program-card' }
  PROGRAM_CARD_ADD_BTN = { css: '.select-button:not(.disabled)' }
  SERVICE_TYPE_FILTER = { css: '#service-types-all-filter' }
  SERVICE_TYPE_FILTER_SELECTED = { css: '#service-types-filter' }
  SELECTED_SERVICE_TYPES = { css: '#service-types-filter .selected-options' }
  SERVICE_TYPE_OPTION = { css: '#service-types-all-filter .ui-filter-option.level-1' }
  SERVICE_TYPES_DROPDOWN_OPEN = { css: '#service-types-filter button.open' }

  def page_displayed?
    is_displayed?(FIND_PROGRAMS_CONTAINER) &&
      is_displayed?(MORE_FILTERS_BTN) &&
      (is_displayed?(SERVICE_TYPE_FILTER) || is_displayed?(SERVICE_TYPE_FILTER_SELECTED))
  end

  def add_programs_from_table(program_count:)
    program_count.times do
      add_random_program_from_table
    end
  end

  def add_oon_program_from_table
    first_oon_program_card = find_element_containing_text(PROGRAM_CARD, OON_TEXT)
    add_btn = first_oon_program_card.find_element(PROGRAM_CARD_ADD_BTN)
    scroll_to_element_and_click(add_btn)
  end

  def click_next
    click_via_js(NEXT_BUTTON)
  end

  def close_service_types_dropdown
    click(SERVICE_TYPES_DROPDOWN_OPEN)
  end

  def open_random_program_drawer
    click_random(PROGRAM_CARD)
  end

  def select_service_type_by_text(service_type)
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click_element_from_list_by_text(SERVICE_TYPE_OPTION, service_type)
    close_service_types_dropdown
    wait_for_matches
  end

  def select_first_service_type
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FIRST_OPTION)
    close_service_types_dropdown
    wait_for_matches
  end

  def selected_service_type
    click(SERVICE_TYPE_FILTER_SELECTED)
    text(SELECTED_SERVICE_TYPES)
  end

  private

  def add_random_program_from_table
    active_program_btns = find_elements(PROGRAM_CARD_ADD_BTN)
    raise("No active program results found for the selected service type.") if active_program_btns.empty?
    scroll_to_element_and_click(active_program_btns.sample)
  end

  def wait_for_matches
    is_not_displayed?(LOADING_SPINNER) &&
      is_displayed?(PROGRAM_CARD)
  end
end

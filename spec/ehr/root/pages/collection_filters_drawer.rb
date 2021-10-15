# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CollectionFiltersDrawer < BasePage
  OPENED_DRAWER = { css: '.ui-drawer--opened' }.freeze
  TITLE = { css: '.filters-title__text' }.freeze
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn > a > .ui-icon' }.freeze
  BUTTON = { css: 'button' }.freeze

  CLEAR_ALL_LINK = { css: '.clear-all > a' }.freeze
  OPEN_DROPDOWN_FILTER_OPTION = { css: '.dropdown.open .ui-filter-option' }.freeze

  # referrals and cases - service type
  SERVICE_TYPE_FILTER = { id: 'service-types-all-filter' }.freeze

  # referrals and cases - care coordinator
  CARE_COORDINATOR_TEXT = "Care Coordinator"
  CARE_COORDINATOR_SEARCH_INPUT = { css: '#care-coordinator-filter.ui-filter-search__input' }

  # TODO - update this to be more deterministic. Currently EHR doesn't show any 'No Matches' text or
  # component, just keeps displaying the Loading... text forever if no matches
  CARE_COORDINATOR_NO_MATCHES = { css: '.filter-options__container--loading' }

  def drawer_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(TITLE) &&
      is_displayed?(SERVICE_TYPE_FILTER)
  end

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def matches_found?
    is_displayed?(OPEN_DROPDOWN_FILTER_OPTION) &&
      is_not_displayed?(CARE_COORDINATOR_NO_MATCHES)
  end

  def search_for_care_coordinator(keys:)
    click_care_coordinator_dropdown

    click(CARE_COORDINATOR_SEARCH_INPUT)
    enter(keys, CARE_COORDINATOR_SEARCH_INPUT)
  end

  def select_random_care_coordinator_option
    click_care_coordinator_dropdown

    random_option = find_elements(OPEN_DROPDOWN_FILTER_OPTION).sample
    random_option.click
  end

  private

  def click_care_coordinator_dropdown
    click_element_by_text(BUTTON, CARE_COORDINATOR_TEXT)
  end
end

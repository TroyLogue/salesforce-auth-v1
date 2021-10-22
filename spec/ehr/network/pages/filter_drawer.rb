# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class FilterDrawer < BasePage
  OPENED_DRAWER = { css: '.ui-drawer--opened' }
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn--opened > a > .ui-icon' }
  TITLE = { css: '.filters-title__text' }
  CLEAR_ALL_BTN = { css: '#clear-all-btn' }

  # distance filters
  DISTANCE_SELECT = { css: '.ui-geo-filter__distance-select .choices' }
  DISTANCE_OPTIONS = { css: '.ui-geo-filter__distance-select .choices__item' }
  ADDRESS_TYPE_SELECT = { css: '.ui-geo-filter__address-type-select .choices' }
  ADDRESS_TYPE_OPTIONS = { css: '.ui-geo-filter__address-type-select .choices__item' }
  ADDRESS_SELECT = { css: '.ui-geo-filter__address-select .choices' }
  ADDRESS_TEXT_INPUT = { css: '.ui-geo-filter__address-select [type="text"]' }
  ADDRESS_NO_RESULTS = { css: '.choices__item .choices__item--choice has-no-choices' }
  ADDRESS_OPTIONS = { css: '.ui-geo-filter__address-select .choices__item' }

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def filter_address_type_by_text(type)
    click(ADDRESS_TYPE_SELECT)
    click_element_from_list_by_text(ADDRESS_TYPE_OPTIONS, type)
  end

  def filter_distance_by_miles(distance)
    click(DISTANCE_SELECT)
    click_element_from_list_by_text(DISTANCE_OPTIONS, distance)
  end

  def page_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(TITLE)
  end

  def submit_other_address(address)
    filter_address_type_by_text("Other")
    click(ADDRESS_SELECT)
    # enter address:
    enter(address, ADDRESS_TEXT_INPUT)
    #wait for results to load:
    is_not_displayed?(ADDRESS_NO_RESULTS)
    click_element_from_list_by_text(ADDRESS_OPTIONS, address)
  end
end

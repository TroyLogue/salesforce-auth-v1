require_relative '../../../shared_components/base_page'

class NetworkFilterDrawer < BasePage
  OPENED_DRAWER = { css: '.ui-drawer--opened' }
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn > a > .ui-icon' };
  TITLE = { css: '.filters-title__text' }
  CLEAR_ALL_BTN = { css: '#clear-all-btn' }

  # distance filters
  DISTANCE_SELECT = { css: '.ui-geo-filter__distance-select .choices' }
  DISTANCE_OPTION = { css: '.ui-geo-filter__distance-select .choices__item' }
  ADDRESS_TYPE_SELECT = { css: '.ui-geo-filter__address-type-select .choices' }
  ADDRESS_TYPE_OPTION = { css: '.ui-geo-filter__address-type-select .choices__item' }
  ADDRESS_SELECT = { css: '.ui-form-field .ui-geo-filter__address-select' }

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def filter_address_type_by_text(type)
    click(ADDRESS_TYPE_SELECT)
    click_element_from_list_by_text(ADDRESS_TYPE_OPTION, type)
  end

  def filter_distance_by_miles(distance)
    click(DISTANCE_SELECT)
    click_element_from_list_by_text(DISTANCE_OPTION, distance)
  end

  def page_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(TITLE) &&
      is_displayed?(CLEAR_ALL_BTN)
  end

  def submit_other_address(address)
    this.filter_address_type_by_text("Other");
    click(ADDRESS_SELECT)
    # enter address:
    # TODO finish
  end
end

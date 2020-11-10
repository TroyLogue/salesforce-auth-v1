# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class CollectionFiltersDrawer < BasePage
  OPENED_DRAWER = { css: '.ui-drawer--opened' }.freeze
  TITLE = { css: '.collection-filters-title__text' }.freeze
  CLOSE_DRAWER_BTN = { css: '.ui-drawer__close-btn > a > .ui-icon' }.freeze

  BUTTON = { css: 'button' }.freeze
  CLEAR_ALL_LINK = { css: '.clear-all > a' }.freeze
  OPEN_DROPDOWN_FILTER_OPTION = { css: '.dropdown.open .ui-filter-option' }.freeze

  # referrals - sent by
  SENT_BY_BUTTON_TEXT = 'Sent By'
  SENT_BY_FILTER = { id: 'sent-by-filter' }.freeze
  SENT_BY_SEARCH_INPUT = { css: '.ui-filter-search__input' }.freeze
  SENT_BY_NO_MATCHES = { css: '.no-matches' }.freeze

  # referrals and cases - service type
  SERVICE_TYPE_FILTER = { id: 'service-type-filter' }.freeze

  # referrals and cases - status
  STATUS_FILTER = { id: 'status-filter' }.freeze

  def drawer_displayed?
    is_displayed?(OPENED_DRAWER) &&
      is_displayed?(CLOSE_DRAWER_BTN) &&
      is_displayed?(TITLE) &&
      is_displayed?(SERVICE_TYPE_FILTER) &&
      is_displayed?(STATUS_FILTER)
  end

  def close_drawer
    click(CLOSE_DRAWER_BTN)
  end

  def matches_found?
    is_displayed?(OPEN_DROPDOWN_FILTER_OPTION) &&
      is_not_displayed?(SENT_BY_NO_MATCHES)
  end

  def search_for_sender(keys:)
    click_sent_by_dropdown

    click(SENT_BY_SEARCH_INPUT)
    enter(keys, SENT_BY_SEARCH_INPUT)
  end

  def select_random_sent_by_option
    click_sent_by_dropdown

    random_option = find_elements(OPEN_DROPDOWN_FILTER_OPTION).sample
    random_option.click
  end

  private

  def click_sent_by_dropdown
    click_element_by_text(BUTTON, SENT_BY_BUTTON_TEXT)
  end
end

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ReferralsTable < BasePage
  HEADER = { css: '.patient-table-header' }
  LOADING_REFERRALS_MESSAGE_TEXT = 'Loading...'
  MORE_FILTERS_BTN = { xpath: '//span[text()="Filters"]' }
  NO_REFERRALS_MESSAGE_TEXT = 'No referrals here.'
  OUTGOING_REFERRALS_TEXT = { xpath: '//span[text()="Outgoing Referrals"]' }

  SENT_BY_FILTER = { id: 'sent-by-filter' }
  BUTTON = { css: 'button' }.freeze
  SENT_BY_BUTTON_TEXT = 'Sent By'
  SENT_BY_NO_MATCHES = { css: '.no-matches' }.freeze
  SENT_BY_SEARCH_INPUT = { css: '.ui-filter-search__input' }.freeze

  STATUS_FILTER = { css: '#status-filter' }
  OPEN_DROPDOWN_FILTER_OPTION = { css: '.dropdown.open .ui-filter-option' }.freeze

  TABLE_BODY = { css: '.table-component' }
  TABLE_MESSAGE = { css: '.table-component td.text-center' }
  TABLE_ROW = { xpath: '//table/tbody/tr' }

  def table_displayed?
    is_displayed?(HEADER) &&
      is_displayed?(OUTGOING_REFERRALS_TEXT) &&
      is_displayed?(STATUS_FILTER) &&
      is_displayed?(SENT_BY_FILTER) &&
      is_displayed?(MORE_FILTERS_BTN) &&
      is_displayed?(TABLE_BODY)
  end

  def click_filter_button
    click(MORE_FILTERS_BTN)
  end

  def loading_referrals_complete?
    # if referrals are returned then TABLE_MESSAGE will not be displayed
    if is_not_displayed?(TABLE_MESSAGE)
      true
    # if no referrals are returned then TABLE_MESSAGE will be displayed but LOADING_REFERRALS_MESSAGE_TEXT will not
    elsif find_element_by_text(TABLE_MESSAGE, LOADING_REFERRALS_MESSAGE_TEXT).nil?
      true
    # if neither of the above conditions are met then referrals are not loaded
    else
      false
    end
  end

  def no_referrals_message_displayed?
    true if is_displayed?(TABLE_MESSAGE, 1) && text(TABLE_MESSAGE) == NO_REFERRALS_MESSAGE_TEXT
  end

  def referrals_displayed?
    is_displayed?(TABLE_ROW, 1)
  end

  def search_for_sender(keys:)
    click_sent_by_dropdown

    click(SENT_BY_SEARCH_INPUT)
    enter(keys, SENT_BY_SEARCH_INPUT)
  end

  def matches_found?
    is_displayed?(OPEN_DROPDOWN_FILTER_OPTION) &&
      is_not_displayed?(SENT_BY_NO_MATCHES)
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

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ReferralsTable < BasePage
  HEADER = { css: '.header-title__text' }.freeze
  FILTER_BUTTON = { id: 'header-title-filter-button' }.freeze

  TABLE_MESSAGE = { css: '.ui-expandable__body  > .message' }.freeze
  LOADING_REFERRALS_MESSAGE_TEXT = 'Loading Referrals'
  NO_REFERRALS_MESSAGE_TEXT = 'No referrals to display'

  TABLE_ROW = { css: '.referrals-table .ui-table-row' }.freeze

  def table_displayed?
    is_displayed?(HEADER) &&
      is_displayed?(FILTER_BUTTON)
  end

  def click_filter_button
    click(FILTER_BUTTON)
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
end

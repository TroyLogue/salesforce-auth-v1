# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class PendingConsentPage < BasePage
  FILTERS_BAR = { css: '.filter-bar' }.freeze
  TABLE_BODY = { css: '#sent-referrals-table .ui-table-body' }.freeze
  PENDING_CONSENT_REFERRAL_FIRST = { css: '.ui-table-body tr:nth-of-type(1)' }.freeze
  REFERRALS_TABLE = { css: '.dynamic-table' }.freeze
  REQUEST_OR_UPLOAD_CONSENT_BUTTON = { css: '#vertical-dots-menu-item-0' }.freeze
  CLOSE_REFERRAL_BUTTON = { css: '#vertical-dots-menu-item-1' }.freeze
  VERTICAL_DOTS_MENU_FIRST = { css: '#-pending-consent-referrals-table-row-0 #vertical-dots-menu' }.freeze
  VERTICAL_DOTS_MENU = { css: '#vertical-dots-menu' }.freeze

  def open_first_consent_modal
    click(VERTICAL_DOTS_MENU)
    click(REQUEST_OR_UPLOAD_CONSENT_BUTTON)
  end

  def open_first_close_referral_modal
    click(VERTICAL_DOTS_MENU)
    click(CLOSE_REFERRAL_BUTTON)
  end

  def page_displayed?
    is_displayed?(FILTERS_BAR)
    is_displayed?(REFERRALS_TABLE)
  end

  def text_of_first_referral
    text(PENDING_CONSENT_REFERRAL_FIRST)
  end

  def text_of_referrals_table
    text(REFERRALS_TABLE)
  end
end

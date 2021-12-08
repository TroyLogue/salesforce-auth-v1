# frozen_string_literal: true

require_relative '../../../../lib/file_helper'

class ReferralNetworkMap < BasePage
  BROWSE_MAP = { css: '.referral-service-provider-browse' }.freeze
  FILTER_SUMMARY_LINK = { css: '#filter-summary-anchor' }.freeze
  ADD_RECIPIENT_BTN = { css: '#shopping-cart-add-providers-btn' }.freeze

  FIRST_ORG_CARD = { css: '.ui-provider-card__info' }.freeze
  FIRST_ORG_CARD_NAME = { css: '.ui-provider-card__name' }.freeze
  FIRST_ORG_ADD = { css: '.ui-provider-card.group-list-item .ui-add-remove-buttons__add' }.freeze
  FIRST_ORG_REMOVE = { css: '.ui-provider-card.group-list-item .ui-add-remove-buttons__remove' }.freeze

  DETAILS_DRAWER = { css: 'referral-create-group-details group-details' }.freeze
  DETAILS_DRAWER_ADD_BTN = { css: '.add-button' }.freeze
  DETAILS_DRAWER_REMOVE_BTN = { css: '.remove-button' }.freeze

  FILTER_DRAWER = { css: '.ui-drawer--opened .browse-filters-drawer__body' }.freeze
  FILTER_DRAWER_CLEAR_ALL = { css: '.ui-drawer--opened .browse-filters-drawer__header-clear-all:not(.hidden) a' }.freeze
  CLOSE_DRAWER_BUTTON = { css: '.ui-drawer__close-btn.ui-drawer__close-btn--opened > a' }.freeze

  def page_displayed?
    is_displayed?(BROWSE_MAP)
  end

  def address_summary
    text(FILTER_SUMMARY_LINK)
  end

  def open_first_organization_drawer
    click(FIRST_ORG_CARD)
    is_displayed?(DETAILS_DRAWER)
  end

  def add_first_organization_from_list
    click(FIRST_ORG_ADD)
    is_not_displayed?(FILTER_DRAWER, 2)
    text(FIRST_ORG_CARD_NAME)
  end

  def add_organizations_to_referral
    click(ADD_RECIPIENT_BTN)
  end

  def clear_all_filters_and_close_drawer
    click_via_js(FILTER_SUMMARY_LINK)
    is_displayed?(FILTER_DRAWER)
    click(FILTER_DRAWER_CLEAR_ALL)
    click_via_js(CLOSE_DRAWER_BUTTON)
  end
end

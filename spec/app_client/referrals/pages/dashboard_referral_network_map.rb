require_relative '../../../../lib/file_helper'

class ReferralNetworkMap < BasePage
  BROWSE_MAP = { css: '.referral-service-provider-browse' }
  FILTER_SUMMARY_LINK = { css: '#filter-summary-anchor'}

  FIRST_ORG_CARD = { css: 'ui-provider-card__info' }
  FIRST_ORG_ADD = { css: '.ui-provider-card.group-list-item .ui-add-remove-buttons__add' }
  FIRST_ORG_REMOVE = { css: '.ui-provider-card.group-list-item .ui-add-remove-buttons__remove'}

  DETAILS_DRAWER = { css: 'referral-create-group-details group-details' }
  DETAILS_DRAWER_ADD_ACTION = { css: '.add-button' }
  DETAILS_DRAWER_REMOVE_ACTION = { css: '.remove-button' }

  def page_displayed?
    is_displayed?(BROWSE_MAP)
  end

  def open_first_organization_drawer
    click(FIRST_ORG_CARD)
    is_displayed?(DETAILS_DRAWER)
  end

  def add_first_organization
    click(FIRST_ORG_ADD)
  end
end

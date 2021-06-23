# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NetworkOrganizations < BasePage
  # search
  SEARCH_BY_NAME_INPUT = { id: 'search-text' }.freeze

  # filters
  SERVICE_TYPE_FILTER = { css: '#service-type-filter' }.freeze
  SERVICE_TYPE_FILTER_ORG = { css: '#service-type-filter' }.freeze
  NETWORK_FILTER = { css: '#network-filter' }.freeze
  NETWORK_FILTER_ORG = { css: '#network-filter' }.freeze
  NETWORK_SCOPE_FILTER = { css: '#network-scope-filter' }.freeze
  LOAD_SPINNER = { css: '.spinning' }.freeze

  # providers list
  PROVIDERS_TABLE = { css: '.network-groups__table' }.freeze
  TABLE_OPT_FIRST = { css: '#network-group-row-0 .ui-table-row-column' }.freeze
  PROVIDER_ROW = { css: '.network-groups__table .ui-table-body .network-groups__group-row' }.freeze
  ORG_TAB_GROUP_OPT_FIRST = { css: '#network-group-row-0' }.freeze
  OUT_OF_NETWORK_ORG = { css: '.ui-table-row-column span[data-tooltip="Out of Network Organization"]' }.freeze
  OON_LOGO = { css: '#OON-icon:nth-of-type(1)' }.freeze

  def page_displayed?
    is_displayed?(SERVICE_TYPE_FILTER) &&
      is_displayed?(NETWORK_FILTER) &&
      is_displayed?(PROVIDERS_TABLE) &&
      is_displayed?(PROVIDER_ROW)
  end

  def click_first_provider_row
    click(TABLE_OPT_FIRST)
  end

  def search_for_provider(provider:)
    clear_then_enter(provider, SEARCH_BY_NAME_INPUT)
    # delay in search results, waiting for spinning icon to appear and then dissapear 
    is_displayed?(LOAD_SPINNER)
    is_not_displayed?(LOAD_SPINNER)
  end
end

require_relative '../../../shared_components/base_page'

class NetworkBrowseMap < BasePage

  # filters
  SEARCH_BAR = { css: '#browse-search-input' }
  SERVICE_TYPE_FILTER = { css: '#service-type-filter' }
  NETWORK_FILTER = { css: '#network-filter' }
  NETWORK_SCOPE_FILTER = { css: '#network-scope-filter' }
  # only the parent div of the select-list options are clickable
  # if and when the has pseudo-selector is supported we can improve the css to be distinct using #in-network and #out-of-network ids
  # https://drafts.csswg.org/selectors-4/#relational
  NETWORK_SCOPE_FILTER_FIRST_OPTION = { css: '#network-scope-filter .ui-filter__options div:nth-child(2)' }
  NETWORK_SCOPE_FILTER_FIRST_OPTION_LABEL = { css: '#network-scope-filter .ui-filter__options div:nth-child(2) label' }
  NETWORK_SCOPE_FILTER_SELECTED_SPAN = { css: '#network-scope-filter div.selected-options span'}

  # providers list
  PROVIDER_CARD = { css: '.ui-provider-card.group-list-item' }
  PROVIDER_CARD_FIRST = { css: '.ui-provider-card.group-list-item:nth-of-type(1)' }
  PROVIDER_CARD_DETAIL_FIRST = { css: '.ui-provider-card__detail:nth-of-type(1)' }
  PROVIDER_CARD_ADD_REMOVE_BUTTON_FIRST = { css: '.provider-card-add-remove-button a:nth-of-type(1)' }
  PROVIDER_CARD_OON = { css: '.ui-provider-card__detail > .ui-provider-card__oon' }

  def click_first_provider_detail
    click(PROVIDER_CARD_DETAIL_FIRST)
  end

  def click_filter_by_network_scope
    click(NETWORK_SCOPE_FILTER)
  end

  def page_displayed?
    # filters
    is_displayed?(SEARCH_BAR) &&
    is_displayed?(SERVICE_TYPE_FILTER) &&
    is_displayed?(NETWORK_FILTER) &&
    is_displayed?(NETWORK_SCOPE_FILTER) &&

    # providers_list_elements
    is_displayed?(PROVIDER_CARD_FIRST)
  end

  def provider_card_displayed?
    is_displayed?(PROVIDER_CARD)
  end

  def provider_card_oon_not_displayed?
    is_not_displayed?(PROVIDER_CARD_OON)
  end

  def select_first_network_scope
    click(NETWORK_SCOPE_FILTER_FIRST_OPTION)
  end

  def selected_option_text
    return text(NETWORK_SCOPE_FILTER_SELECTED_SPAN)
  end

  def text_of_first_network_scope
    return text(NETWORK_SCOPE_FILTER_FIRST_OPTION_LABEL)
  end

end

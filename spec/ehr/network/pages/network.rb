require_relative '../../../shared_components/base_page'

class Network < BasePage
  INDEX_EHR = { css: '.network-directory-index' }
  NTH_PROVIDER_CARD = { css: '.ui-provider-select-cards > .ui_provider_card:nth_child("%d")' }
  NTH_PROVIDER_CARD_NAME = { css: '.ui_provider_card:nth_child("%d") > .ui-provider-card__name' }
  SERVICE_TYPE_FILTER = { css: '#service-type-filter' }
  NETWORK_FILTER = { css: '#network-filter' }
  SEARCH_FILTER = { css: '#referral-search-filter' }
  RESULT_TEXT_DIV = { css: '.filter-summary__results-text' }

  def first_provider_name
    nth_provider_name(0)
  end

  def nth_provider_card(index)
    # css indexes start at 1 not 0:
    NTH_PROVIDER_CARD.transform_values { |v| v % (index + 1) }
  end

  def nth_provider_name(index)
    # css indexes start at 1 not 0:
    text(NTH_PROVIDER_CARD_NAME.transform_values { |v| v % (index + 1) })
  end

  def page_displayed?
    is_displayed?(INDEX_EHR) &&
      is_displayed?(SERVICE_TYPE_FILTER) &&
      is_displayed?(NETWORK_FILTER) &&
      is_displayed?(SEARCH_FILTER)
  end

  def search_by_text(text:)
    enter(text, SEARCH_FILTER)
  end

  def search_result_text
    text(RESULT_TEXT_DIV)
  end
end

require_relative '../../../shared_components/base_page'

class Network < BasePage
  BAR_LOADER = { css: '.bar-loader' }
  INDEX_EHR = { css: '.network-directory-index' }
  PROVIDER_CARDS_CONTAINER = { css: '.ui-provider-select-cards' }
  PROVIDER_CARD = { css: '.ui-provider-card' }
  SERVICE_TYPE_FILTER = { css: '#service-type-filter' }
  NETWORK_FILTER = { css: '#network-filter' }
  SEARCH_FILTER = { css: '#referral-search-filter' }
  RESULT_TEXT_DIV= { css: '.filter-summary__results-text' }

  def first_provider_name
    nth_provider_name(0)
  end

  def nth_provider_card_selector(index)
    # css indexes start at 1 not 0:
    @nth_provider_card = { css: ".ui-provider-select-cards .ui-provider-card:nth-child(#{index + 1})" }
  end

  def nth_provider_name(index)
    # css indexes start at 1 not 0:
    @nth_provider_card_name = { css: ".ui-provider-card:nth-child(#{index + 1}) .ui-provider-card__name" }
    text(@nth_provider_card_name)
  end

  def page_displayed?
    is_displayed?(INDEX_EHR) &&
      is_displayed?(SERVICE_TYPE_FILTER) &&
      is_displayed?(NETWORK_FILTER) &&
      is_displayed?(SEARCH_FILTER)
  end

  def search_by_text(text:)
    enter(text, SEARCH_FILTER)

    # wait for results to update:
    is_not_displayed?(BAR_LOADER)
  end

  def search_result_text
    text(RESULT_TEXT_DIV)
  end

  def select_service_type(service_type)
  end
end

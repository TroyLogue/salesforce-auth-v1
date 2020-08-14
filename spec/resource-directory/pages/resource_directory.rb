require_relative '../../shared_components/base_page'

class ResourceDirectory < BasePage
  FILTER_CONTAINER = { css: '.filter-container' }
  FIRST_PROVIDER_NAME_CONTAINER = { css: '.list-item .h3.name' }
  RESULTS_CONTAINER = { css: '.list-listener-container' }
  RESULTS_LOADING = { css: '.list-item.loading' }
  PROVIDER_RESULT = { xpath: './/h3[text()="%s"]' }
  MAP_CONTAINER = { css: '.map-container' }

  def page_displayed?
    is_displayed?(FILTER_CONTAINER) &&
    is_displayed?(RESULTS_CONTAINER) &&
    is_displayed?(MAP_CONTAINER)
  end

  def find_result_by_name(name)
    find(PROVIDER_RESULT.transform_values { |v| v % name })
  end

  def get_first_provider_name
    text(FIRST_PROVIDER_NAME_CONTAINER)
  end

  def results_loaded?
    is_not_displayed?(RESULTS_LOADING) &&
      !(get_first_provider_name.empty?)
  end
end

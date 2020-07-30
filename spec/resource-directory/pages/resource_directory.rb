require_relative '../../shared_components/base_page'

class ResourceDirectory < BasePage
  FILTER_CONTAINER = { css: '.filter-container' }
  RESULTS_CONTAINER = { css: '.list-listener-container' }
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
end

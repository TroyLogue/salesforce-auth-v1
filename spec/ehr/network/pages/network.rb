require_relative '../../../shared_components/base_page'

class Network < BasePage
  INDEX_EHR = { css: '.network-directory-index' }

  def page_displayed?
    is_displayed?(INDEX_EHR)
  end
end

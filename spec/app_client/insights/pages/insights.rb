# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class Insights < BasePage
  TABLEAU_IFRAME = { css: '#tableau-viz iframe' }.freeze

  def tableau_iframe_displayed?
    is_displayed?(TABLEAU_IFRAME)
  end
end

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class GroupSelectorPage < BasePage
  CONTAINER = { css: '#container .group-selector' }.freeze
  HEADER = { css: ' .group-selector__header' }.freeze
  PROVIDER_BUTTON = { css: '.ui-button.ui-button--primary.group-selector-item' }.freeze
  FIRST_PROVIDER = { css: '.group-selector__choices [id^=group]:first-of-type' }.freeze

  def page_displayed?
    is_displayed?(CONTAINER) &&
      is_displayed?(HEADER)
  end

  def number_of_provider_buttons
    find_elements(PROVIDER_BUTTON).length
  end

  def select_first_provider
    click FIRST_PROVIDER
  end
end

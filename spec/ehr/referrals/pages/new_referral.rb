# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  BAR_LOADER = { css: '.bar-loader' }
  FILTER_BTN = { css: '#common-card-title-filter-button' }
  NEW_REFERRAL_CONTAINER = { css: '.new-referral' }
  SELECTED_SERVICE_TYPE = { css: '.service-type-select__select-field .choices' }

  def page_displayed?
    is_displayed?(NEW_REFERRAL_CONTAINER) &&
      is_displayed?(FILTER_BTN) &&
      is_not_displayed?(BAR_LOADER)
  end

  def selected_service_type
    text(SELECTED_SERVICE_TYPE)
  end
end

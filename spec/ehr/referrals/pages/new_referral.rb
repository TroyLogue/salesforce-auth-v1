# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  SELECTED_SERVICE_TYPE = { css: '.service-type-select__select-field .choices' }

  def selected_service_type
    text(SELECTED_SERVICE_TYPE)
  end
end

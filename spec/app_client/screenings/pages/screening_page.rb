# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class ScreeningPage < BasePage
  SCREENING_DETAIL = { class: 'screening-detail' }
  NO_NEEDS_DISPLAY = { css: '.risk-display__no-needs' }
  IDENTIFIED_SERVICE_CARD_TITLES = { css: '.risk-display .ui-base-card .ui-base-card-header__title' }
  IDENTIFIED_SERVICE_CARDS = { css: '.risk-display .ui-base-card' }

  def page_displayed?
    is_displayed?(SCREENING_DETAIL)
    wait_for_spinner
  end

  def no_needs_displayed?
    is_displayed?(NO_NEEDS_DISPLAY)
  end

  def needs_identified?
    find_elements(IDENTIFIED_SERVICE_CARD_TITLES).each_with_index do |need, index|
      service_type_message = "This client has been determined to have a #{need.text} need."
      service_card_text = find_elements(IDENTIFIED_SERVICE_CARDS)[index].text
      raise "E2E Error: Expected #{service_type_message}. Got #{service_card_text}" unless service_card_text.include?(service_type_message)
    end
  end
end
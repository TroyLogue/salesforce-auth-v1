# frozen_string_literal: true

module CreateReferral
  class AddReferral < BasePage
    THIRD_STEP = { css: '.MuiStep-root:nth-of-type(5) > button .MuiStepLabel-active' }.freeze
    REFERRAL_FORM = { css: '.referral-service-form-expanded' }.freeze
    INFO_TEXT = { css: '.info-panel__text' }.freeze

    EXPAND_SERVICE_CHOICES = { css: '.service-type-dropdown' }.freeze
    ID_SERVICE_CHOICE = { css: 'div[id^="choices-service-type-item"][data-value="%s"]' }.freeze
    BROWSE_MAP_LINK = { css: '#browse-map-button' }.freeze

    WARNING_REGULAR = 'Only include personally identifiable information (PII), protected health information (PHI), or other sensitive information if it is necessary to provide services to the client.'
    WARNING_SENSITIVE = 'If this referral is for a 42 CFR Part 2 covered service, Part 2 prohibits the unauthorized re-disclosure of these records.'

    def page_displayed?
      wait_for_spinner
      is_displayed?(THIRD_STEP) &&
        is_displayed?(REFERRAL_FORM) &&
        is_displayed?(INFO_TEXT)
    end

    def warning_info_text
      text(INFO_TEXT)
    end

    def select_service_type_by_id(id:)
      click(EXPAND_SERVICE_CHOICES)
      click(ID_SERVICE_CHOICE.transform_values { |v| v % id })
      wait_for_spinner
    end

    def open_network_browse_map
      click(BROWSE_MAP_LINK)
    end
  end
end

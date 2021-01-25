# frozen_string_literal: true

require_relative '../../root/pages/notifications'

module OrgSettings
  class ProgramTable < BasePage
    PROGRAMS_TABLE = { css: '.programs' }.freeze
    PROGRAMS_TABLE_LOAD = { xpath: 'h2[text()="Loading Programs..."]' }.freeze
    PROGRAMS_LIST = { css: '.ui-base-card-header__title' }.freeze
    PROGRAM_EDIT = { xpath: './/h2[text()="%s"]/following-sibling::div/div/button' }.freeze
    NEW_PROGRAM_BTN = { css: '[aria-label="New Program"]' }.freeze
    PROGRAMS_CARD = { css: '.program-card' }.freeze

    def page_displayed?
      is_not_displayed?(PROGRAMS_TABLE_LOAD)
      is_displayed?(PROGRAMS_TABLE)
    end

    def get_list_of_programs
      names = find_elements(PROGRAMS_LIST)
      names_array = names.collect(&:text)
    end

    def edit_program(name:)
      click(PROGRAM_EDIT.transform_values { |v| v % name })
    end

    def get_program_description(name:)
      text(PROGRAM_DESCRIPTION.transform_values { |v| v % name })
    end

    def go_to_new_program_form
      click(NEW_PROGRAM_BTN)
    end

    def are_changes_saved?
      is_displayed?(Notifications::SUCCESS_BANNER)
    end
  end

  class ProgramForm < BasePage
    PROGRAM_HEADER = { css: '.ui-base-card-header__title' }.freeze
    INPUT_PROGRAM_NAME = { css: '#program-name' }.freeze
    CHECKBOX_PROGRAM_REFERRAL = { css: 'label[for="program-referral-toggle"]' }.freeze
    TEXT_PROGRAM_REFERRAL_CONTENT = { css: '.referral-content' }.freeze
    INPUT_PROGRAM_DESCRIPTION = { css: '#program-description' }.freeze
    INPUT_PAYMENT_OPTIONS = { css: '#program-payment-options' }.freeze
    INPUT_ACCESSIBILITY_OPTIONS = { css: '#program-accessibility-options' }.freeze
    INPUT_TRANSPORTATION = { css: '#program-transportation-options' }.freeze
    INPUT_SERVICE_DELIVERY = { css: 'div[aria-activedescendant^="choices-program-service-delivery-options-item-choice"]' }.freeze
    INPUT_POPULATION_RESTRICTION = { css: 'div[aria-activedescendant^="choices-program-populations-restricted-to-item-choice"]' }.freeze
    INPUT_POPULATION_CATERED = { css: 'div[aria-activedescendant^="choices-program-populations-catered-to-item-choice"]' }.freeze
    INPUT_STATE = { css: 'div[aria-activedescendant^="choices-program-us-states-item-choice"]' }.freeze
    INPUT_COUNTY = { css: 'label[for="program-us-counties"]' }.freeze
    INPUT_CITIES = { css: 'label[for="program-us-cities"]' }.freeze
    INPUT_LANGUAGE = { css: 'div[aria-activedescendant^="choices-program-languages-item-choice"]' }.freeze
    INPUT_SERVICE_TYPES = { css: '.service-types-checkboxes' }.freeze
    INPUT_PROGRAM_ELIGIBILITY = { css: '#program-eligibility' }.freeze
    UPDATE_BTN = { css: '#new-program-submit-btn' }.freeze

    def page_displayed?
      is_displayed?(INPUT_PROGRAM_NAME) && is_displayed?(CHECKBOX_PROGRAM_REFERRAL) && is_displayed?(INPUT_PROGRAM_DESCRIPTION) &&
        is_displayed?(INPUT_PAYMENT_OPTIONS) && is_displayed?(INPUT_ACCESSIBILITY_OPTIONS) && is_displayed?(INPUT_TRANSPORTATION) &&
        is_displayed?(INPUT_SERVICE_DELIVERY) && is_displayed?(INPUT_POPULATION_RESTRICTION) && is_displayed?(INPUT_POPULATION_CATERED) &&
        is_displayed?(INPUT_STATE) && is_displayed?(INPUT_COUNTY) && is_displayed?(INPUT_CITIES) && is_displayed?(INPUT_LANGUAGE) &&
        is_displayed?(INPUT_SERVICE_TYPES) && is_displayed?(INPUT_PROGRAM_ELIGIBILITY)
    end

    def get_program_title
      text(PROGRAM_HEADER)
    end

    def save_changes
      click(UPDATE_BTN)
      is_not_displayed?(UPDATE_BTN, 5)
    end

    def get_program_referral_dialog
      text(TEXT_PROGRAM_REFERRAL_CONTENT)
    end

    def toggle_program_referral
      click(CHECKBOX_PROGRAM_REFERRAL)
    end

    def is_program_referral_on?
      is_selected?(CHECKBOX_PROGRAM_REFERRAL)
    end
  end
end

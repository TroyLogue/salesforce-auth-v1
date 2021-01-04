# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  # TODO auto-recall checkbox: replace xpath with id when UU3-50317 is complete
  AUTO_RECALL_CHECKBOX = { xpath: '//*[@id="root"]/div/div[2]/div[2]/div/div/div[1]/div[2]/div/div/form/div[4]/div/div/div[1]' }
  BAR_LOADER = { css: '.bar-loader' }
  DESCRIPTION_FIELD = { css: '#referral-notes' }
  FILTER_BTN = { css: '#common-card-title-filter-button' }
  NEW_REFERRAL_CONTAINER = { css: '.new-referral' }
  PROVIDER_CARD = { css: '.ui-provider-card' }
  PROVIDER_CARD_BY_TEXT = { xpath: "//h4[@class='ui-provider-card__name' and text()='%s']/ancestor::div[@class='ui-provider-card']" }
  PROVIDER_CARD_NAME = { css: '.ui-provider-card__name' }
  PROVIDER_CARD_ADD_BTN = { css: '.ui-add-remove-buttons__add' }
  SERVICE_TYPE_FILTER = { css: '.service-type-select__select-field .choices' }
  SERVICE_TYPE_OPTION = { css: '.choices__item--selectable' }
  SUBMIT_BTN = { css: '#create-referral-submit-btn' }

  def add_provider_via_table_by_name(provider)
    provider_card = PROVIDER_CARD_BY_TEXT.transform_values { |v| v % provider }
    click_within(provider_card, PROVIDER_CARD_ADD_BTN)
  end

  def add_random_provider_from_table
    click_random(PROVIDER_CARD_ADD_BTN)
  rescue StandardError => e
    info_message = "No provider card add buttons were found. "\
                   "This can happen when there are no remaining unselected "\
                   "providers for the selected service type, "\
                   "or when the first selected provider is a Coordination Center."
    raise StandardError, "#{e.message}: #{info_message}"
  end

  def enter_description(description)
    enter(description, DESCRIPTION_FIELD)
  end

  def open_provider_drawer_by_name(provider)
    click_element_by_text(PROVIDER_CARD_NAME, provider)
  end

  def open_random_provider_drawer
    click_random(PROVIDER_CARD)
  end

  def page_displayed?
    is_displayed?(NEW_REFERRAL_CONTAINER)
      is_displayed?(FILTER_BTN)
      is_displayed?(SERVICE_TYPE_FILTER)
  end

  def select_auto_recall
    click(AUTO_RECALL_CHECKBOX)
  end

  def select_providers_from_table_by_name(providers)
    providers.each do |provider|
      add_provider_via_table_by_name(provider)
    end
  end

  def select_service_type_by_text(service_type)
    click(SERVICE_TYPE_FILTER)
    click_element_from_list_by_text(SERVICE_TYPE_OPTION, service_type)
    wait_for_matches
  end

  def selected_service_type
    text(SERVICE_TYPE_FILTER)
  end

  def submit
    click(SUBMIT_BTN)
  end

  def wait_for_matches
    is_not_displayed?(BAR_LOADER) &&
      is_displayed?(PROVIDER_CARD)
  end
end

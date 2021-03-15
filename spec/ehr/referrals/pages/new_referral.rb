# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  # TODO auto-recall checkbox: replace xpath with id when UU3-50317 is complete
  ADD_ANOTHER_REFERRAL_BUTTON = { css: '#add-referral-btn'}
  AUTO_RECALL_CHECKBOX = { xpath: '//*[@id="root"]/div/div[2]/div[2]/div/div/div[1]/div[2]/div/div/form/div[4]/div/div/div[1]' }
  BAR_LOADER = { css: '.bar-loader' }
  DESCRIPTION_FIELD = { css: '#referral-notes' }
  FILTER_BTN = { css: '#common-card-title-filter-button' }
  NEW_REFERRAL_CONTAINER = { css: '.new-referral' }
  NO_CHOICES_ITEMS = { css: '.has-no-choices' }
  OUT_OF_NETWORK_TAB = { css: '#oon-toggle-out-btn' }
  PRIMARY_WORKER_DROPDOWN = { css: '.referral-primary-worker .choices' }
  PRIMARY_WORKER_OPTION = { css: '.referral-primary-worker .choices__item' }
  PROVIDER_CARD = { css: '.ui-provider-card' }
  PROVIDER_CARD_BY_TEXT = { xpath: "//h4[@class='ui-provider-card__name' and text()='%s']/ancestor::div[@class='ui-provider-card']" }
  PROVIDER_CARD_DISABLED = { css: '.ui-provider-card__info-disabled' }
  PROVIDER_CARD_ENABLED = { css: '.ui-provider-card__info:not(.ui-provider-card__info-disabled)' }
  PROVIDER_CARD_NAME = { css: '.ui-provider-card__name' }
  PROVIDER_CARD_ADD_BTN = { css: '.ui-add-remove-buttons__add' }
  PROVIDER_CARD_REMOVE_BTN = { css: '.ui-add-remove-buttons__remove' }
  SERVICE_TYPE_FILTER = { css: '.service-type-select__select-field .choices' }
  SERVICE_TYPE_OPTION = { css: '.choices__item--selectable' }
  SERVICE_TYPE_FIRST_OPTION = { css: '#choices-service-type-item-choice-2' }
  SUBMIT_BTN = { css: '#create-referral-submit-btn' }

  def add_random_provider_from_table
    click_random(PROVIDER_CARD_ADD_BTN) unless cc_selected?
  rescue StandardError => e
    info_message = "No more provider results for the selected service type."
    raise StandardError, "#{e.message}: #{info_message}"
  end

  # send 'oon: true' to create an Out of Network referral
  def create_referral_from_table(service_type:, description:, provider_count: 1, oon: false)
    select_service_type_by_text(service_type)
    select_out_of_network if oon
    provider_count.times do
      add_random_provider_from_table unless provider_preselected?
    end
    enter_description(description)
    primary_worker = oon ? set_primary_worker_to_random_option : ''
    submit

    # return primary worker (for oon referrals)
    primary_worker
  end

  def enter_description(description)
    enter(description, DESCRIPTION_FIELD)
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

  def select_service_type_by_text(service_type)
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click_element_from_list_by_text(SERVICE_TYPE_OPTION, service_type)
    wait_for_matches
  end

  def select_first_service_type
    is_displayed?(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FILTER)
    click(SERVICE_TYPE_FIRST_OPTION)
    wait_for_matches
  end

  def selected_service_type
    text(SERVICE_TYPE_FILTER)
  end

  def add_another_referral
    click(ADD_ANOTHER_REFERRAL_BUTTON)
  end

  def fill_out_referral(description:, oon: false)
    select_first_service_type
    select_out_of_network if oon
    add_random_provider_from_table
    enter_description(description)
    set_primary_worker_to_random_option if oon
  end

  def submit
    click(SUBMIT_BTN)
  end

  private

  def add_provider_via_table_by_name(provider)
    provider_card = PROVIDER_CARD_BY_TEXT.transform_values { |v| v % provider }
    click_within(provider_card, PROVIDER_CARD_ADD_BTN)
  end

  def cc_selected?
    # if a CC was selected, all other provider cards will be disabled
    count(PROVIDER_CARD_ENABLED) == 1 &&
      count(PROVIDER_CARD_DISABLED) > 0 &&
      count(PROVIDER_CARD_REMOVE_BTN) == 1
  end

  def open_primary_worker_dropdown
    click(PRIMARY_WORKER_DROPDOWN)
    is_not_displayed?(NO_CHOICES_ITEMS)
  end

  def open_provider_drawer_by_name(provider)
    click_element_by_text(PROVIDER_CARD_NAME, provider)
  end

  def provider_preselected?
    # if there is only one provider result, they will be pre selected
    # also confirm that the add button is already checked
    count(PROVIDER_CARD) == 1 && count(PROVIDER_CARD_ADD_BTN) == 0
  end

  def select_out_of_network
    click(OUT_OF_NETWORK_TAB)
    wait_for_matches
  end

  def select_providers_from_table_by_name(providers)
    providers.each do |provider|
      add_provider_via_table_by_name(provider)
    end
  end

  def set_primary_worker_to_random_option
    open_primary_worker_dropdown

    random_option = find_elements(PRIMARY_WORKER_OPTION).sample
    worker_name = random_option.text.strip
    random_option.click

    worker_name
  end

  def wait_for_matches
    is_not_displayed?(BAR_LOADER) &&
      is_displayed?(PROVIDER_CARD)
  end
end

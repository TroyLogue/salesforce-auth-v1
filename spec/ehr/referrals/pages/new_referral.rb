# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  # TODO auto-recall checkbox: replace xpath with id when UU3-50317 is complete
  AUTO_RECALL_CHECKBOX = { xpath: '//*[@id="root"]/div/div[2]/div[2]/div/div/div[1]/div[2]/div/div/form/div[4]/div/div/div[1]' }
  BAR_LOADER = { css: '.bar-loader' }
  CONTINUE_BTN = { css: '#create-referral-submit-btn' }
  DESCRIPTION_FIELD = { css: '#referral-notes' }
  FILTER_BTN = { css: '#common-card-title-filter-button' }
  NEW_REFERRAL_CONTAINER = { css: '.new-referral' }
  PROVIDER_CARD = { css: '.ui-provider-card' }
  PROVIDER_CARD_NAME = { css: '.ui-provider-card__name' }
  #not sure if this is working right
  PROVIDER_CARD_BY_NAME = { xpath: './/*[@class="ui-provider-card]/div/div/h4[text()="%s"]' }

  PROVIDER_CARD_ADD_BTN = { css: '.ui-add-remove-buttons__add' }
  SERVICE_TYPE_FILTER = { css: '.service-type-select__select-field .choices' }
  SERVICE_TYPE_OPTION = { css: '.choices__item--selectable' }

  # need to clean up / fix these methods!
=begin
  def add_provider_via_table(provider)
    click(PROVIDER_CARD_BY_NAME)
    provider_card = find_element_by_text(PROVIDER_CARD, provider)
    provider_card.find_element(PROVIDER_CARD_ADD_BTN).click
  end
=end

  def click_continue
    click(CONTINUE_BTN)
  end

  def enter_description(description)
    enter(description, DESCRIPTION_FIELD)
  end

  def open_provider_drawer(provider)
    click_element_by_text(PROVIDER_CARD_NAME, provider)
  end

  def page_displayed?
    is_displayed?(NEW_REFERRAL_CONTAINER)
      is_displayed?(FILTER_BTN)
      is_displayed?(SERVICE_TYPE_FILTER)
    true
  end

  def select_auto_recall
    click(AUTO_RECALL_CHECKBOX)
  end

  def select_providers_from_table(providers)
    providers.each do |provider|
      add_provider_via_table(provider)
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

  def wait_for_matches
    is_not_displayed?(BAR_LOADER) &&
      is_displayed?(PROVIDER_CARD)
  end
end

# frozen_string_literal: true

require_relative '../../../shared_components/base_page'

class NewReferral < BasePage
  # TODO auto-recall checkbox: replace with id when UU3-50317 is complete
  AUTO_RECALL_CHECKBOX = { xpath: '//*[@id="root"]/div/div[2]/div[2]/div/div/div[1]/div[2]/div/div/form/div[4]/div/div/div[1]' }
  COLUMBIA_ADD_BTN = { xpath: '//*[@id="serviceTypeGroups"]/div[1]/div/div[2]/div[2]/div/div/a' }
  PRINCETON_ADD_BTN = { xpath: '//*[@id="serviceTypeGroups"]/div[1]/div/div[3]/div[2]/div/div/a' }
  BAR_LOADER = { css: '.bar-loader' }
  CONTINUE_BTN = { css: '#create-referral-submit-btn' }
  DESCRIPTION_FIELD = { css: '#referral-notes' }
  FILTER_BTN = { css: '#common-card-title-filter-button' }
  NEW_REFERRAL_CONTAINER = { css: '.new-referral' }
  PROVIDER_CARD = { css: '.ui-provider-card' }
  SERVICE_TYPE_FILTER = { css: '.service-type-select__select-field .choices'}
  SERVICE_TYPE_OPTION = { css: '.choices__item--selectable' }

  def add_providers_via_table
    # TODO remove this hardcoded method
    click(COLUMBIA_ADD_BTN)
    click(PRINCETON_ADD_BTN)
  end

  def add_provider_via_table(provider)
    #TODO
  end

  def add_provider_via_drawer(provider)
    #TODO
  end

  def click_continue
    click(CONTINUE_BTN)
  end

  def enter_description(description)
    enter(description, DESCRIPTION_FIELD)
  end

  def page_displayed?
    is_displayed?(NEW_REFERRAL_CONTAINER) &&
      is_displayed?(FILTER_BTN) &&
      is_displayed?(SERVICE_TYPE_FILTER)
  end

  def select_auto_recall
    click(AUTO_RECALL_CHECKBOX)
  end

  def select_providers_from_drawer(providers)
    providers.each do |provider|
      add_provider_via_drawer(provider)
    end
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

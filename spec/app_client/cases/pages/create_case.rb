# frozen_string_literal: true

require_relative '../../../shared_components/base_page'
require_relative '../../../../lib/file_helper'

class CreateCase < BasePage
  AUTO_SELECTED_PROGRAM = { css: '#program + div > div:not(button)' }.freeze
  CASE_DETAILS = { css: '.add-case-details' }.freeze
  CASE_INFORMATION_NEXT_BUTTON = { css: '#add-case-details-next-btn' }.freeze
  CREATE_CASE_FORM = { css: '.add-case-details' }.freeze
  DESCRIPTION = { css: '#description' }.freeze
  EXPAND_OON_ORG = { css: '#select-field-oon-group-0 + .choices__list' }.freeze
  NEXT_BTN = { css: '#add-case-details-next-btn' }.freeze
  OON_ORG_FIRST_OPTION = { id: 'choices-select-field-oon-group-0-item-choice-3' }.freeze
  OON_PROGRAM = 'Referred Out of Network'
  PRIMARY_WORKER_DROPDOWN = { css: '#primary-worker + .choices__list' }.freeze
  PRIMARY_WORKER_FIRST_OPTION = { css: '#choices-primary-worker-item-choice-2' }.freeze
  PRIMARY_WORKER_NO_MATCHES = { css: '.has-no-results' }.freeze
  PRIMARY_WORKER_SEARCH_INPUT = { css: '.choices__list.choices__list--dropdown.is-active > input' }.freeze
  PROGRAM_DROPDOWN = { css: '#program + .choices__list' }.freeze
  PROGRAM_FIRST_OPTION = { css: '#choices-program-item-choice-2' }.freeze
  REMOVE_TEXT = 'Remove item'
  SERVICE_TYPE_DROPDOWN = { css: '#service-type + .choices__list' }.freeze
  SERVICE_TYPE_FIRST_OPTION = { css: '#choices-service-type-item-choice-2' }.freeze
  SELECTED_OON_ORG = { css: '#select-field-oon-group-0 + div > div:not(button)' }.freeze
  SELECT_PRIMARY_WORKER = { css: '#primary-worker + div > div:not(button)' }.freeze
  SELECTED_SERVICE_TYPE = { css: '#service-type + div > div:not(button)' }.freeze
  SUBMIT_CASE_BUTTON = { css: '#submit-case-btn' }.freeze
  SUPPORTING_INFORMATION_NEXT_BUTTON = { css: '#next-btn' }.freeze
  SUPPORTING_INFORMATION_PAGE = { css: '.ui-form-field__label' }.freeze

  # Uploads:
  DOCUMENT_UPLOAD_CONTEXT = { css: '.dropzone' }
  DOCUMENT_UPLOAD_INPUT = { css: 'input[type="file"]' }
  DOCUMENT_PREVIEW = { css: '.preview-item' }

  def page_displayed?
    is_displayed?(CASE_DETAILS)
  end

  def advance_to_review_step
    click(CASE_INFORMATION_NEXT_BUTTON)
    click(SUPPORTING_INFORMATION_NEXT_BUTTON) if is_displayed?(SUPPORTING_INFORMATION_PAGE)
  end

  def click_next_button
    click(NEXT_BTN)
  end

  def create_case_form_displayed?
    is_displayed?(CREATE_CASE_FORM)
  end

  def create_new_case(program_id:, service_type_id:, primary_worker_id:)
    select_program(program_id)
    select_service_type(service_type_id)
    select_primary_worker(primary_worker_id)
    advance_to_review_step
    click(SUBMIT_CASE_BUTTON)
  end

  # the search for primary worker calls a different endpoint than get/select
  # some specs may include the variation rather than having all create-case specs selecting the first primary-worker option
  # (e.g., in contrast to create_oon_case_selecting_first_options)
  def create_case_selecting_first_options_and_searching_for_primary_worker(description:, primary_worker_search_keys:)
    select_first_program
    select_first_service_type
    search_and_select_primary_worker(keys: primary_worker_search_keys)
    enter_description(description)

    submitted_case_selections = {
      service_type: selected_service_type,
      primary_worker: selected_primary_worker
    }

    advance_to_review_step
    # return selections for comparison
    submitted_case_selections
  end

  def create_oon_case_selecting_first_options(description:, file_name:)
    select_first_service_type
    select_first_oon_org
    select_first_primary_worker
    enter_description(description)

    upload_document(file_name: file_name) if file_name

    submitted_case_selections = {
      service_type: selected_service_type,
      org: selected_oon_org,
      primary_worker: selected_primary_worker
    }

    advance_to_review_step
    # return selections for comparison
    submitted_case_selections
  end

  def description_text
    text(DESCRIPTION)
  end

  def enter_description(description)
    enter(description, DESCRIPTION)
  end

  def is_oon_program_auto_selected?
    OON_PROGRAM == text(AUTO_SELECTED_PROGRAM).sub!(REMOVE_TEXT, '').strip!
  end

  def select_first_options
    select_first_service_type
    select_first_oon_org
    select_first_primary_worker

    submitted_case_selections = {
      service_type: selected_service_type,
      org: selected_oon_org,
      primary_worker: selected_primary_worker
    }
  end

  def select_primary_worker(primary_worker_id)
    primary_worker = { css: "div[data-value='#{primary_worker_id}']" }
    click(PRIMARY_WORKER_DROPDOWN)
    click(primary_worker)
  end

  def select_program(program_id)
    program = { css: "div[data-value='#{program_id}']" }
    click(PROGRAM_DROPDOWN)
    click(program)
  end

  def select_service_type(service_type_id)
    service_type = { css: "div[data-value='#{service_type_id}']" }
    click(SERVICE_TYPE_DROPDOWN)
    click(service_type)
  end

  def upload_document(file_name:)
    # creating a local file with an identifiable name
    local_file_path = create_consent_file(file_name)
    enter_within(local_file_path, DOCUMENT_UPLOAD_CONTEXT, DOCUMENT_UPLOAD_INPUT)
    is_displayed?(DOCUMENT_PREVIEW)
    # deleting local file
    delete_consent_file(file_name)
  end

  private

  def search_and_select_primary_worker(keys:)
    click(PRIMARY_WORKER_DROPDOWN)

    click(PRIMARY_WORKER_SEARCH_INPUT)
    enter(keys, PRIMARY_WORKER_SEARCH_INPUT)
    is_not_displayed?(PRIMARY_WORKER_NO_MATCHES)

    click(PRIMARY_WORKER_FIRST_OPTION)
  end

  def select_first_oon_org
    click(EXPAND_OON_ORG)
    click(OON_ORG_FIRST_OPTION)
  end

  def select_first_primary_worker
    click(PRIMARY_WORKER_DROPDOWN)
    click(PRIMARY_WORKER_FIRST_OPTION)
  end

  def select_first_program
    click(PROGRAM_DROPDOWN)
    click(PROGRAM_FIRST_OPTION)
  end

  def select_first_service_type
    click(SERVICE_TYPE_DROPDOWN)
    click(SERVICE_TYPE_FIRST_OPTION)
  end

  def selected_oon_org
    # Removing distance and "Remove Item" to return just the provider name
    provider_text = text(SELECTED_OON_ORG)
    provider_distance_index = text(SELECTED_OON_ORG).rindex(/\(/) # finds the last open paren in the string
    provider_text[0..(provider_distance_index - 1)].strip # returns provider_text up to the distance
  end

  def selected_primary_worker
    text(SELECT_PRIMARY_WORKER).sub!(REMOVE_TEXT, '').strip!
  end

  def selected_service_type
    text(SELECTED_SERVICE_TYPE).sub!(REMOVE_TEXT, '').strip!
  end
end

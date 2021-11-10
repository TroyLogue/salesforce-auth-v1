# frozen_string_literal: true

require_relative '../../../../lib/file_helper'

class Referral < BasePage
  ASSESSMENT_LIST = { css: '.detail-info__relationship-files' }.freeze
  ASSESSMENT_LINK = { xpath: './/a[text()="%s"]' }.freeze
  MILITARY_ASSESSMENT = { css: '#military-information-link' }.freeze
  REFERRAL_STATUS = { css: '.detail-status-text.uppercase' }.freeze
  OUTCOME_NOTES = { css: '#outcome-notes-expandable p' }.freeze
  INACTIVE_BTN = { css: '.detail-action-wrapper > span' }.freeze
  CLOSED_BY = { css: '#outcome-column-one-table-closed-by-value' }.freeze
  SERVICE_TYPE = { css: '.referral-service-type' }.freeze
  DESCRIPTION = { css: '#detail-description-expandable .expandable-container__content .add-line-breaks' }.freeze

  EDIT_REFERRAL_BTN = { css: '#edit-referral-network-btn' }.freeze
  EDIT_REFERRAL_MODAL = { css: '#edit-referral-network-modal.dialog.open.large .dialog-paper' }.freeze
  EDIT_REFERRAL_ORG_CHOICES = { css: '#select-field-group-0 + div' }.freeze
  EDIT_REFERRAL_FIRST_ORG = { css: '#choices-select-field-group-0-item-choice-2' }.freeze
  EDIT_REFERRAL_SAVE_BTN = { css: '#edit-draft-referral-submit-btn' }.freeze
  EDIT_REFERRAL_SELECTED_ORG = { css: '#select-field-group-0 + div > div:not(button)' }.freeze

  TAKE_ACTION_DROP_DOWN = { css: '.action-select-container' }.freeze
  TAKE_ACTION_HOLD_OPTION = { css: 'div[data-value="holdForReview"]' }.freeze
  TAKE_ACTION_SEND_OPTION = { css: 'div[data-value^="send"]' }.freeze
  TAKE_ACTION_ACCEPT_OPTION = { css: 'div[data-value="accept"]' }.freeze
  TAKE_ACTION_REJECT_OPTION = { css: 'div[data-value="reject"]' }.freeze
  TAKE_ACTION_INTAKE_OPTION = { css: 'div[data-value="startIntake"]' }.freeze
  TAKE_ACTION_CLOSE_OPTION = { css: 'div[data-value="closeReferral"]' }.freeze
  TAKE_ACTION_CLOSE_REFERRAL_BTN = { css: '#take-action-close-referral-btn' }.freeze

  ACCEPT_MODAL = { css: '.accept-modal-dialog .dialog.open.large .dialog-paper' }.freeze
  ACCEPT_PROGRAM_OPTIONS = { css: 'div[aria-activedescendant="choices-programSelect-item-choice-1"]' }.freeze
  ACCEPT_FIRST_PROGRAM_OPTION = { css: '#choices-programSelect-item-choice-1' }.freeze
  ACCEPT_PRIMARY_WORKER_OPTIONS = { css: '.accept-referral-primary-worker-select .choices:not(.is-disabled)' }.freeze
  ACCEPT_FIRST_PRIMARY_WORKER_OPTION = { css: '#choices-workerSelect-item-choice-1' }.freeze
  ACCEPT_SAVE_BTN = { css: '#accept-referral-submit-btn' }.freeze

  HOLD_REFERRAL_MODAL = { css: '.dialog.open.large .hold-modal-form' }.freeze
  HOLD_REFERRAL_REASON_DROPDOWN = { css: '.dialog.open.large .referral-reason-field' }.freeze
  HOLD_REFERRAL_REASON_OPTION = { css: '.is-active .choices__item.choices__item--choice.choices__item--selectable' }.freeze
  HOLD_REFERRAL_NOTE = { css: '.hold-modal-form #noteInput' }.freeze
  HOLD_REFERRAL_BTN = { css: '#hold-referral-hold-btn' }.freeze

  CLOSE_REFERRAL_MODAL = { css: '.dialog.open.large .close-referral-form' }.freeze
  CLOSE_RESOLVED_DROPDOWN = { css: '#resolvedInput + div' }.freeze
  CLOSE_RESOLVED_OPTION = { css: '#choices-resolvedInput-item-choice-1' }.freeze
  CLOSE_UNRESOLVED_OPTION = { css: '#choices-resolvedInput-item-choice-2' }.freeze
  CLOSE_OUTCOME_DROPDOWN = { css: '#outcomeInput + div' }.freeze
  CLOSE_OUTCOME_OPTION = { css: '#choices-outcomeInput-item-choice-1' }.freeze
  CLOSE_REFERRAL_NOTE = { css: '.close-referral-form #noteInput' }.freeze
  CLOSE_REFERRAL_BTN = { css: '#close-referral-close-btn' }.freeze

  SENDER_INFO = { css: '#basic-table-sender-value' }.freeze
  RECIPIENT_INFO = { css: "td[id^='basic-table-recipient']" }.freeze

  REJECT_REFERRAL_MODAL = { css: '.reject-modal-dialog .open' }.freeze
  REJECT_REFERRAL_REASON_DROPDOWN = { css: '.referral-reject-display .referral-reason-field .choices__inner' }.freeze
  REJECT_REFERRAL_REASON_OPTION = { css: '.referral-reason-field .choices.is-open #choices-reject-reason-input-item-choice-1' }.freeze
  REJECT_REFERRAL_REASON_OPTIONS = { css: '.referral-reason-field div[id^="choices-reject-reason-input-item-choice-"]' }.freeze
  REJECT_REFERRAL_NOTE = { css: '#reject-note-input' }.freeze
  REJECT_BTN = { css: '.referral-reject-display__reject-modal-form #reject-referral-reject-btn' }.freeze

  ASSIGN_CARE_COORDINATOR_LINK = { css: '#assign-care-coordinator-link' }.freeze
  ASSIGN_CARE_COORDINATOR_MODAL = { css: '#care-coordinator-modal.dialog.open.normal .dialog-paper' }.freeze
  ASSIGN_CARE_COORDINATOR_DROPDOWN = { css: '.care-coordinator-select .choices' }.freeze
  ASSIGN_CARE_COORDINATOR_CHOICES = { css: '.is-active div[id^="choices-care-coordinator"]' }.freeze
  ASSIGN_CARE_COORDINATOR_SELECTED = { css: '#care-coordinator-selector + div > div:not(button)' }.freeze
  ASSIGN_CARE_COORDINATOR_BUTTON = { css: '#edit-care-coordinator-assign-btn' }.freeze
  CURRENT_CARE_COORDINATOR = { css: '.edit-care-coordinator > span' }.freeze

  VIEW_INTAKE_LINK = { css: '.intake-label__link' }.freeze

  DOCUMENT_ADD_LINK = { css: '#upload-document-link' }.freeze
  DOCUMENT_ATTACH_MODAL = { css: '.dialog.open.large' }.freeze
  DOCUMENT_ATTACH_BTN = { css: '#upload-submit-btn' }.freeze
  DOCUMENT_FILE_INPUT = { css: 'input[type="file"]' }.freeze
  DOCUMENT_PREVIEW = { css: '.preview-item' }.freeze
  DOCUMENT_LIST = { css: '.list-view-document__title' }.freeze
  DOCUMENT_EMPTY_LIST = { css: '.empty-documents-text' }.freeze

  DOCUMENT_LINK = { xpath: './/a[text()="%s"]' }.freeze
  DOCUMENT_REMOVE = { xpath: './/a[text()="%s"]/following-sibling::div[@class="remove-document"]' }.freeze
  DOCUMENT_REMOVE_MODAL = { css: '.dialog.open.mini' }.freeze
  DOCUMENT_REMOVE_BTN = { css: '.confirmation-dialog__actions--confirm' }.freeze

  INTERACTION_TAB = { css: '#interactions-interaction-tab' }.freeze
  OTHER_TAB = { css: '#interactions-other-tab' }.freeze
  # Does not currently exist in Referral View, used for neg testing
  SERVICES_TAB = { css: '#interactions-service-provided-tab' }.freeze

  TIMELINE_LOADING = { css: '.activity-stream .loading-entries__content' }.freeze
  STATUS_TEXT = { css: '.detail-status-text' }.freeze

  NEEDS_ACTION_STATUS = 'NEEDS ACTION'
  IN_REVIEW_STATUS = 'IN REVIEW'
  ACCEPTED_STATUS = 'ACCEPTED'
  REJECTED_STATUS = 'REJECTED'
  CLOSED_STATUS = 'CLOSED'

  CLOSED_REFERRAL_ACTION = 'REFERRAL CLOSED'
  REMOVE_TEXT = 'Remove item'

  REJECTED_OPTION = [
    'Client is not eligible for our services',
    'Duplicate, case already exists in the system',
    'We do not have capacity to serve client',
    'We do not provide the services requested/needed',
    'We were unable to contact the client',
    'Other'
  ].freeze

  def go_to_new_referral_with_id(referral_id:)
    get("/dashboard/new/referrals/#{referral_id}")
    wait_for_spinner
  end

  def path_of_new_referral_with_id(referral_id:)
    "/dashboard/new/referrals/#{referral_id}"
  end

  def go_to_in_review_referral_with_id(referral_id:)
    get("/dashboard/referrals/in-review/#{referral_id}")
    wait_for_spinner
  end

  def go_to_sent_referral_with_id(referral_id:)
    get("/dashboard/referrals/sent/all/#{referral_id}")
    wait_for_spinner
  end

  def go_to_rejected_referral_with_id(referral_id:)
    get("/dashboard/referrals/rejected/#{referral_id}")
    wait_for_spinner
  end

  def go_to_recalled_referral_with_id(referral_id:)
    get("/dashboard/referrals/recalled/#{referral_id}")
    wait_for_spinner
  end

  def go_to_closed_referral_with_id(referral_id:)
    get("/dashboard/referrals/closed/#{referral_id}")
    wait_for_spinner
  end

  def go_to_p2p_referral_with_id(referral_id:)
    get("/dashboard/referrals/provider-to-provider/#{referral_id}")
    wait_for_spinner
  end

  def go_to_sent_pending_consent_referral_with_id(referral_id:)
    get("/dashboard/referrals/sent/pending-consent/#{referral_id}")
    wait_for_spinner
  end

  def go_to_draft_referral_with_id(referral_id:)
    get("/dashboard/referrals/drafts/#{referral_id}")
    wait_for_spinner
  end

  def page_displayed?
    wait_for_spinner
    is_displayed?(STATUS_TEXT) &&
      is_not_displayed?(TIMELINE_LOADING)
  end

  def action_btn_text
    text(INACTIVE_BTN)
  end

  def status
    text(REFERRAL_STATUS)
  end

  def closed_by
    text(CLOSED_BY)
  end

  def current_referral_id
    uri = URI.parse(driver.current_url)
    uri.path.split('/').last
  end

  def recipient_info
    text(RECIPIENT_INFO)
  end

  def outcome_notes
    text(OUTCOME_NOTES)
  end

  def service_type
    text(SERVICE_TYPE).capitalize
  end

  def description
    text(DESCRIPTION)
  end

  def referral_summary_info
    {
      service_type: service_type,
      recipients: recipient_info,
      description: description
    }
  end

  # ACCEPT
  def accept_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_ACCEPT_OPTION)
    is_displayed?(ACCEPT_MODAL)
    click_via_js(ACCEPT_PROGRAM_OPTIONS)
    click(ACCEPT_FIRST_PROGRAM_OPTION)
    click_via_js(ACCEPT_PRIMARY_WORKER_OPTIONS)
    click(ACCEPT_FIRST_PRIMARY_WORKER_OPTION)
    click(ACCEPT_SAVE_BTN)
    wait_for_spinner
  end

  # HOLD FOR REVIEW
  def hold_for_review_action(note:)
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_HOLD_OPTION)
    is_displayed?(HOLD_REFERRAL_MODAL)
    is_displayed?(HOLD_REFERRAL_REASON_DROPDOWN)
    click(HOLD_REFERRAL_REASON_DROPDOWN)
    is_displayed?(HOLD_REFERRAL_REASON_OPTION)
    click(HOLD_REFERRAL_REASON_OPTION)
    enter(note, HOLD_REFERRAL_NOTE)
    click(HOLD_REFERRAL_BTN)
    wait_for_spinner
  end

  # CLOSE
  def submit_close_referral_modal(note:)
    is_displayed?(CLOSE_REFERRAL_MODAL) && is_displayed?(CLOSE_REFERRAL_BTN)

    # wait for glide-in animation
    # explicit waits don't avoid element click intercepted errors
    # added challenge to consider with front-end rewrite https://uniteus.atlassian.net/wiki/spaces/QA/pages/2278490206/Front-end+Rewrite+Historical+Testing+Challenges#animation
    sleep(1)

    # Selecting resolved option by default
    click(CLOSE_RESOLVED_DROPDOWN)
    click(CLOSE_RESOLVED_OPTION)
    wait_for_element_to_disappear(CLOSE_RESOLVED_OPTION) if check_displayed?(CLOSE_RESOLVED_OPTION)

    # Selecing first outcome option by default
    click(CLOSE_OUTCOME_DROPDOWN)
    click(CLOSE_OUTCOME_OPTION)
    wait_for_element_to_disappear(CLOSE_OUTCOME_OPTION) if check_displayed?(CLOSE_OUTCOME_OPTION)

    enter(note, CLOSE_REFERRAL_NOTE)
    click(CLOSE_REFERRAL_BTN)
    wait_for_spinner
  end

  def close_referral_action(note:)
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_CLOSE_OPTION)

    submit_close_referral_modal(note: note)
  end

  # P2P referrals only have the option to close a referral
  def close_referral_through_btn(note:)
    click(TAKE_ACTION_CLOSE_REFERRAL_BTN)
    submit_close_referral_modal(note: note)
  end

  # REJECT
  def reject_referral_options_displayed?
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_REJECT_OPTION)
    is_displayed?(REJECT_REFERRAL_MODAL)
    click(REJECT_REFERRAL_REASON_DROPDOWN)

    non_matching = find_elements(REJECT_REFERRAL_REASON_OPTIONS).collect(&:text) - REJECTED_OPTION
    non_matching.empty? or print "Non-matching options: #{non_matching}"
  end

  def reject_referral_action(note:)
    click(REJECT_REFERRAL_REASON_OPTION)
    enter(note, REJECT_REFERRAL_NOTE)
    click(REJECT_BTN)
    wait_for_spinner
  end

  # SEND
  def send_referral_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_SEND_OPTION)
  end

  # INTAKE
  def start_intake_action
    click(TAKE_ACTION_DROP_DOWN)
    click(TAKE_ACTION_INTAKE_OPTION)
  end

  # DOCUMENTS
  def attach_document_to_referral(file_name:)
    click(DOCUMENT_ADD_LINK)
    is_displayed?(DOCUMENT_ATTACH_MODAL)
    local_file_path = create_consent_file(file_name)
    enter(local_file_path, DOCUMENT_FILE_INPUT)
    is_displayed?(DOCUMENT_PREVIEW)
    click(DOCUMENT_ATTACH_BTN)
    # deleting local file
    delete_consent_file(file_name)
  end

  def document_list
    text(DOCUMENT_LIST)
  end

  def no_documents?
    is_displayed?(DOCUMENT_EMPTY_LIST)
  end

  def remove_document_from_referral(file_name:)
    hover_over(DOCUMENT_LINK.transform_values { |v| v % file_name })
    click(DOCUMENT_REMOVE.transform_values { |v| v % file_name })
    is_displayed?(DOCUMENT_REMOVE_MODAL)
    click(DOCUMENT_REMOVE_BTN)
  end

  # ASSSESMENTS
  def assessment_list
    text(ASSESSMENT_LIST)
  end

  def military_assessment_displayed?
    wait_for { find_elements(ASSESSMENT_LIST).length > 1 }
    is_displayed?(MILITARY_ASSESSMENT)
  end

  def open_assessment(assessment_name:)
    click(ASSESSMENT_LINK.transform_values { |v| v % assessment_name })
  end

  def open_military_assessment
    click(MILITARY_ASSESSMENT)
  end

  # EDITS
  def open_edit_referral_modal
    click(EDIT_REFERRAL_BTN)
    wait_for_spinner
    is_displayed?(EDIT_REFERRAL_MODAL)
  end

  def add_recipient_in_edit_referral_modal
    click(EDIT_REFERRAL_ORG_CHOICES)
    click(EDIT_REFERRAL_FIRST_ORG)

    # Removing distance and "Remove Item" to return just the provider name
    selected_org = text(EDIT_REFERRAL_SELECTED_ORG)
    distance = selected_org.rindex(/\(/) # finds the last open paren in the string
    selected_org[0..(distance - 1)].strip # returns provider_text up to the distance
  end

  def save_edit_referral_modal
    click(EDIT_REFERRAL_SAVE_BTN)
    wait_for_spinner
  end

  # Care Coordinator
  def assign_first_care_coordinator
    click(ASSIGN_CARE_COORDINATOR_LINK)
    is_displayed?(ASSIGN_CARE_COORDINATOR_MODAL)
    # ensure dropdown is displayed before trying to click to avoid StaleElementReference
    is_displayed?(ASSIGN_CARE_COORDINATOR_DROPDOWN)

    # 'None' is an option among the care coordinator choices; we need to make sure it's not submitted
    # CORE-1120 improvement ticket to move None out of alphabetic order
    default_retry_count = 10
    retry_count = 0
    coordinator = 'None'
    while coordinator == 'None' && retry_count <= default_retry_count
      click_via_js(ASSIGN_CARE_COORDINATOR_DROPDOWN)
      click_random(ASSIGN_CARE_COORDINATOR_CHOICES)
      # Return name of care coordinator to use later, removing unwanted text
      coordinator = text(ASSIGN_CARE_COORDINATOR_SELECTED).sub!(REMOVE_TEXT, '').split('(')[0].strip!
      # logging the coordinator value in case retry_count reaches max with None selected;
      # given the unlikelihood of that happening, we will want proof in case of the StandardError being raised
      # this logging can be removed when CORE-1120 is addressed
      p "E2E DEBUG: care coordinator at retry count #{retry_count} is #{coordinator}"
      retry_count += 1
      coordinator
    end

    raise StandardError, 'Invalid test condition: Coordinator is None' if coordinator == 'None'

    click(ASSIGN_CARE_COORDINATOR_BUTTON)
    wait_for_spinner
    coordinator
  end

  # Intakes
  def is_intake_link_displayed?
    is_displayed?(VIEW_INTAKE_LINK)
  end

  def click_view_intake_link
    click(VIEW_INTAKE_LINK)
    wait_for_spinner
  end

  def current_care_coordinator
    is_displayed?(CURRENT_CARE_COORDINATOR)
    text(CURRENT_CARE_COORDINATOR)
  end

  # notes
  def notes_section_displayed?
    # SERVICE TAB should never be visible in the Referral view
    is_displayed?(INTERACTION_TAB) &&
      is_displayed?(OTHER_TAB) &&
      is_not_displayed?(SERVICES_TAB)
  end
end

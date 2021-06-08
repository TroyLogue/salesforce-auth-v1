# frozen_string_literal: true

module ReferralDashboard
  module SharedComponents
    HEADER_COLUMNS = { css: '.ui-table-header-column' }.freeze
    LOCKED_MESSAGE = { css: '.unauthorized-message' }.freeze

    CARE_COORDINATOR_FILTER = { css: '#care-coordinator-filter.ui-filter' }.freeze
    CARE_COORDINATOR_OPTIONS = { css: '#care-coordinator-filter .ui-filter-option .ui-label-roman' }.freeze
    CARE_COORDINATOR_INPUT = { css: '#care-coordinator-filter.ui-filter-search__input' }.freeze
    CARE_COORDINATOR_LOAD = { css: '.filter-options__container--loading' }.freeze
    CARE_COORDINATOR_FIRST = { css: '.ui-filter-option' }.freeze

    SERVICE_TYPE_DROPDOWN = { id: 'service-type-filter' }.freeze
    SERVICE_TYPE_OPTION_BY_ID = { css: 'label[for="%s"]' }.freeze

    EMPTY_TABLE = { css: '.empty-table' }.freeze
    EMPTY_SENT_REFERRALS = { css: '.empty-table__message' }.freeze

    UNAUTHORIZED_MESSAGE = "Client is not being served by your organization. [20001]\nClient has not granted consent. [20000]"

    def headers_displayed?
      displayed_headers = find_elements(HEADER_COLUMNS)[1..].map(&:text)
      non_matching = self.class::HEADERS - displayed_headers | displayed_headers - self.class::HEADERS
      non_matching.empty? or raise("Non-matching headers: #{non_matching}")
    end

    def cc_headers_displayed?
      displayed_headers = find_elements(HEADER_COLUMNS)[1..].map(&:text)
      non_matching = self.class::CC_HEADERS - displayed_headers | displayed_headers - self.class::CC_HEADERS
      non_matching.empty? or raise("Non-matching headers: #{non_matching}")
    end

    def org_headers_displayed?
      displayed_headers = find_elements(HEADER_COLUMNS)[1..].map(&:text)
      non_matching = self.class::ORG_HEADERS - displayed_headers | displayed_headers - self.class::ORG_HEADERS
      non_matching.empty? or raise("Non-matching headers: #{non_matching}")
    end

    def row_values_for_client(client:)
      # List of client names
      clients = find_elements(self.class::ALL_CLIENT_NAMES).map(&:text)
      # Return indexes that match client name
      indexes = clients.filter_map.with_index { |name, index| index if name == client }
      raise("#{client} not found in table") unless indexes.any?

      # Return an array of strings
      client_values = []
      indexes.each do |index|
        client_values << find_elements(self.class::CLIENT_ROW.transform_values { |v| v % (index + 1) }).map(&:text).join(', ')
      end
      # Returning an array of strings if multiple results, otherwise a single string
      client_values.count > 1 ? client_values : client_values[0]
    end

    def click_on_row_by_client_name(client:)
      list_clients = find_elements(self.class::ALL_CLIENT_NAMES).map(&:text)
      index = list_clients.index(client) || raise("#{client} not found in table")
      client_locator = self.class::CLIENT_ROW.transform_values { |v| v % (index + 1) }
      click(client_locator)
    end

    def pop_up_message
      text(LOCKED_MESSAGE)
    end

    def is_empty_table_displayed?
      is_displayed?(EMPTY_TABLE)
    end

    def no_referrals_message_displayed?
      is_displayed?(EMPTY_SENT_REFERRALS) && text(EMPTY_SENT_REFERRALS) == self.class::NO_REFERRALS_TEXT
    end

    def filter_by_care_coordinator(coordinator:)
      click(CARE_COORDINATOR_FILTER)
      clear_then_enter(coordinator, CARE_COORDINATOR_INPUT)
      is_not_displayed?(CARE_COORDINATOR_LOAD)
      click(CARE_COORDINATOR_FIRST)
      wait_for_spinner
    end

    def filter_by_random_care_coordinator
      click(CARE_COORDINATOR_FILTER)
      element = find_elements(CARE_COORDINATOR_OPTIONS).sample
      care_cooordinator = element.text
      element.click
      care_cooordinator
    end

    def filtered_by_care_coordinator?(care_coordinator:)
      # None Assigned maps to an empty value for care coordinator row
      care_coordinator = '' if care_coordinator == 'None Assigned'

      care_coords = find_elements(self.class::CARE_COORDINATORS_ROW_VALUES).map(&:text)
      care_coords.all? { |cc| cc == care_coordinator }
    end

    def filter_by_service_type_id(id:)
      click(SERVICE_TYPE_DROPDOWN)
      click(SERVICE_TYPE_OPTION_BY_ID.transform_values { |v| v % id })
    end

    def filtered_by_service_type?(type:)
      service_types = find_elements(self.class::SERVICE_TYPE_ROW_VALUES).map(&:text)
      service_types.all? { |t| t == type }
    end
  end

  class New < BasePage
    include SharedComponents

    NEW_REFERRALS = { id: 'new-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="new-referrals-table-row"] .ui-table-row-column:nth-child(3) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="new-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze
    CARE_COORDINATORS_ROW_VALUES = { css: 'tr[id^="new-referrals-table-row"] .ui-table-row-column:nth-child(5) > span' }.freeze
    SERVICE_TYPE_ROW_VALUES = { css: 'tr[id^="new-referrals-table-row"] .ui-table-row-column:nth-child(4) > span' }.freeze

    CC_HEADERS = ['SENDER', 'CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'STATUS', 'DATE RECEIVED'].freeze
    ORG_HEADERS = ['SENDER', 'CLIENT NAME', 'SERVICE TYPE', 'STATUS', 'DATE RECEIVED'].freeze

    NO_REFERRALS_TEXT = 'There are no new referrals.'

    def page_displayed?
      wait_for_spinner
      is_displayed?(NEW_REFERRALS)
    end

    def go_to_new_referrals_dashboard
      get('/dashboard/new/referrals')
    end
  end

  class InReview < BasePage
    include SharedComponents

    IN_REVIEW_REFERRALS = { css: '#referrals-in-review-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="referrals-in-review-table-row"] .ui-table-row-column:nth-child(2) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="referrals-in-review-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    CC_HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'DATE RECEIVED', 'INTERACTIONS', 'LAST UPDATED'].freeze
    ORG_HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'DATE RECEIVED', 'INTERACTIONS', 'LAST UPDATED'].freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(IN_REVIEW_REFERRALS)
    end

    def go_to_in_review_referrals_dashboard
      get('/dashboard/referrals/in-review')
    end
  end

  class Recalled < BasePage
    include SharedComponents

    RECALLED_REFERRALS = { css: '#recalled-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="recalled-referrals-table-row"] .ui-table-row-column:nth-child(3) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="recalled-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze
    RECALLED_DROPDOWN = { id: 'status-filter' }.freeze
    RECALLED_OPTIONS = { css: '#status-filter .ui-filter-option .ui-label-roman' }.freeze
    RECALLED_STATUS_ROW_VALUE = { css: 'tr[id^="recalled-referrals-table"] .ui-table-row-column:nth-child(1) > span' }.freeze

    HEADERS = ['RECALLED FROM', 'CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'DATE RECALLED'].freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(RECALLED_REFERRALS)
    end

    def go_to_recalled_referrals_dashboard
      get('/dashboard/referrals/recalled')
    end
  end

  class Rejected < BasePage
    include SharedComponents

    REJECTED_REFERRALS = { css: '#rejected-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="rejected-referrals-table-row"] .ui-table-row-column:nth-child(2) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="rejected-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze
    CARE_COORDINATORS_ROW_VALUES = { css: 'tr[id^="rejected-referrals-table-row"] .ui-table-row-column:nth-child(4) > span' }.freeze
    HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'REASON REJECTED', 'DATE REJECTED'].freeze

    NO_REFERRALS_TEXT = 'There are no rejected referrals.'

    def page_displayed?
      wait_for_spinner
      is_displayed?(REJECTED_REFERRALS)
    end

    def go_to_rejected_referrals_dashboard
      get('/dashboard/referrals/rejected')
    end
  end

  class ProviderToProvider < BasePage
    include SharedComponents

    P2P_REFERRALS = { css: '#open-channel-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="open-channel-referrals-table-row"] .ui-table-row-column:nth-child(4) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="open-channel-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    HEADERS = ['SENDER', 'RECIPIENT', 'CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'STATUS', 'LAST UPDATED'].freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(P2P_REFERRALS)
    end

    def go_to_p2p_referrals_dashboard
      get('/dashboard/referrals/provider-to-provider')
    end
  end

  class Drafts < BasePage
    include SharedComponents

    DRAFT_REFERRALS = { css: '#draft-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="draft-referrals-table-row"] .ui-table-row-column:nth-child(2) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="draft-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(DRAFT_REFERRALS)
    end

    def go_to_draft_referrals_dashboard
      get('/dashboard/referrals/drafts')
    end
  end

  class Closed < BasePage
    include SharedComponents

    CLOSED_REFERRALS = { css: '#closed-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="closed-referrals-table-row"] .ui-table-row-column:nth-child(4) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="closed-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    HEADERS = ['SENDER', 'RECIPIENT', 'CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'OUTCOME', 'DATE CLOSED'].freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(CLOSED_REFERRALS)
    end

    def go_to_closed_referrals_dashboard
      get('/dashboard/referrals/closed')
    end
  end

  module Sent
    SENT_REFERRALS = { css: '#sent-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="sent-referrals-table-row"] .ui-table-row-column:nth-child(3) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="sent-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze
    SENT_BY_ROW_VALUES = { css: 'tr[id^="sent-referrals-table-row"] .ui-table-row-column:nth-child(4) > span' }.freeze
    STATUS_ROW_VALUES = { css: 'tr[id^="sent-referrals-table-row"] .ui-table-row-column:nth-child(6) > span' }.freeze

    SENT_BY_DROPDOWN = { id: 'sent-by-filter' }.freeze
    SENT_BY_OPTIONS = { css: '#sent-by-filter .ui-filter-option .ui-label-roman' }.freeze

    STATUS_DROPDOWN = { id: 'status-filter' }.freeze
    STATUS_OPTION = { xpath: './/label/span[text()="%s"]' }.freeze

    NO_REFERRALS_TEXT = 'There are no referrals.'

    def page_displayed?
      wait_for_spinner
      is_displayed?(SENT_REFERRALS)
    end

    class All < BasePage
      include SharedComponents
      include Sent
      HEADERS = ['RECIPIENT', 'CLIENT NAME', 'SENT BY', 'SERVICE TYPE', 'STATUS', 'LAST UPDATED'].freeze
      STATUSES = ['Accepted', 'Auto Recalled', 'Closed', 'Declined Consent', 'In Review', 'Needs Action', 'Pending Consent', 'Recalled', 'Rejected'].freeze

      def go_to_sent_all_referrals_dashboard
        get('/dashboard/referrals/sent/all')
      end

      def filter_by_random_sender
        click(SENT_BY_DROPDOWN)
        element = find_elements(SENT_BY_OPTIONS).sample
        sender = element.text
        element.click
        sender
      end

      def filtered_by_sent_by?(sent_by:)
        sent_by_values = find_elements(SENT_BY_ROW_VALUES).map(&:text)
        sent_by_values.all? { |sender| sender == sent_by }
      end

      def filter_by_random_status
        selected_status = STATUSES.sample
        click(STATUS_DROPDOWN)
        click(STATUS_OPTION.transform_values { |v| v % selected_status })
        selected_status
      end

      def filtered_by_status?(status:)
        # Declined Consent and Pending Consent map to status Needs Action
        status = 'Needs Action' if ['Declined Consent', 'Pending Consent'].include?(status)

        status_values = find_elements(STATUS_ROW_VALUES).map(&:text)
        status_values.all? { |state| state.downcase == status.downcase }
      end
    end

    class PendingConsent < BasePage
      include SharedComponents
      include Sent
      # Need the last empty header for the three dot option
      HEADERS = ['RECIPIENT', 'CLIENT NAME', 'SENT BY', 'SERVICE TYPE', 'CONSENT REQUESTS', 'DATE SENT', ''].freeze

      def go_to_sent_pending_consent_referrals_dashboard
        get('/dashboard/referrals/sent/pending-consent')
      end
    end
  end
end

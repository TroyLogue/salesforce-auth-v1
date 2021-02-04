# frozen_string_literal: true

module ReferralDashboard
  module SharedComponents
    HEADER_COLUMNS = { css: '.ui-table-header-column' }.freeze
    LOCKED_MESSAGE = { css: '.unauthorized-message' }.freeze

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
      indexes = clients.filter_map.with_index { |name, index| index if name == client } || raise("#{client} not found in table")
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
  end

  class New < BasePage
    include SharedComponents

    NEW_REFERRALS = { id: 'new-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="new-referrals-table-row"] .ui-table-row-column:nth-child(3) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="new-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    CC_HEADERS = ['SENDER', 'CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'STATUS', 'DATE RECEIVED'].freeze
    ORG_HEADERS = ['SENDER', 'CLIENT NAME', 'SERVICE TYPE', 'STATUS', 'DATE RECEIVED'].freeze

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

    INREVIEW_REFERRALS = { css: '#referrals-in-review-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="referrals-in-review-table-row"] .ui-table-row-column:nth-child(2) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="referrals-in-review-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

    CC_HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'DATE RECEIVED', 'INTERACTIONS', 'LAST UPDATED'].freeze
    ORG_HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'DATE RECEIVED', 'INTERACTIONS', 'LAST UPDATED'].freeze

    def page_displayed?
      wait_for_spinner
      is_displayed?(INREVIEW_REFERRALS)
    end

    def go_to_inreview_referrals_dashboard
      get('/dashboard/referrals/in-review')
    end
  end

  class Recalled < BasePage
    include SharedComponents

    RECALLED_REFERRALS = { css: '#recalled-referrals-table' }.freeze
    ALL_CLIENT_NAMES = { css: 'tr[id^="recalled-referrals-table-row"] .ui-table-row-column:nth-child(3) > span' }.freeze
    CLIENT_ROW = { css: 'tr[id^="recalled-referrals-table-row"]:nth-child(%s) .ui-table-row-column > span' }.freeze

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

    HEADERS = ['CLIENT NAME', 'SERVICE TYPE', 'CARE COORDINATOR', 'REASON REJECTED', 'DATE REJECTED'].freeze

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

    def page_displayed?
      wait_for_spinner
      is_displayed?(SENT_REFERRALS)
    end

    class All < BasePage
      include SharedComponents
      include Sent
      HEADERS = ['RECIPIENT', 'CLIENT NAME', 'SENT BY', 'SERVICE TYPE', 'STATUS', 'LAST UPDATED'].freeze

      def go_to_sent_all_referrals_dashboard
        get('/dashboard/referrals/sent/all')
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

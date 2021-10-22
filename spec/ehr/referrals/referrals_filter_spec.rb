# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/collection_filters_drawer'
require_relative '../root/pages/notifications_ehr'
require_relative './pages/outgoing_referrals'

describe '[Referrals]', :ehr, :referrals do
  include LoginEhr

  let(:collection_filters_drawer) { CollectionFiltersDrawer.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:notifications_ehr) { NotificationsEhr.new(@driver) }
  let(:outgoing_referrals) { OutgoingReferrals.new(@driver) }

  context('[dashboard view] with filter drawer open') do
    before do
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(outgoing_referrals.page_displayed?).to be_truthy

      outgoing_referrals.click_filter_button
      expect(collection_filters_drawer.drawer_displayed?).to be_truthy
    end

    it 'filters by care coordinator', :uuqa_1618 do
      collection_filters_drawer.select_random_care_coordinator_option
      expect(outgoing_referrals.loading_referrals_complete?).to be_truthy

      expect(notifications_ehr.error_notification_not_displayed?).to be_truthy
      expect(outgoing_referrals.no_referrals_message_displayed? || outgoing_referrals.referrals_displayed?).to be_truthy
    end

    it 'finds care coordinators via search', :uuqa_1619 do
      collection_filters_drawer.search_for_care_coordinator(keys: 'e')
      expect(collection_filters_drawer.matches_found?).to be_truthy
    end
  end

  context('[dashboard view] with filters from table') do
    before do
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(outgoing_referrals.page_displayed?).to be_truthy
    end

    it 'filters by referral sender', :uuqa_1618 do
      outgoing_referrals.select_random_sent_by_option
      expect(outgoing_referrals.loading_referrals_complete?).to be_truthy

      expect(notifications_ehr.error_notification_not_displayed?).to be_truthy
      expect(outgoing_referrals.no_referrals_message_displayed? || outgoing_referrals.referrals_displayed?).to be_truthy
    end

    it 'finds senders via search', :uuqa_1619 do
      outgoing_referrals.search_for_sender(keys: 'e')
      expect(outgoing_referrals.matches_found?).to be_truthy
    end
  end
end

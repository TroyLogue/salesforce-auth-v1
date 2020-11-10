# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/collection_filters_drawer'
require_relative '../root/pages/home_page'
require_relative './pages/referrals_table'

describe '[Referrals]', :ehr, :referrals do
  include LoginEhr

  let(:collection_filters_drawer) { CollectionFiltersDrawer.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:notifications_ehr) { NotificationsEhr.new(@driver) }
  let(:referrals_table) { ReferralsTable.new(@driver) }

  context('[dashboard view] with filter drawer open') do
    before do
      log_in_dashboard_as(LoginEhr::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy

      referrals_table.click_filter_button
      expect(collection_filters_drawer.drawer_displayed?).to be_truthy
    end

    it 'filters by referral sender', :uuqa_1618 do
      collection_filters_drawer.select_random_sent_by_option
      expect(referrals_table.loading_referrals_complete?).to be_truthy

      expect(notifications_ehr.error_notification_not_displayed?).to be_truthy
      expect(referrals_table.no_referrals_message_displayed? | referrals_table.referrals_displayed?).to be_truthy
    end

    it 'finds senders via search', :uuqa_1619 do
      collection_filters_drawer.search_for_sender(keys: 'e')
      expect(collection_filters_drawer.matches_found?).to be_truthy
    end
  end
end

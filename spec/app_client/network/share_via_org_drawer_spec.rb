require_relative '../auth/helpers/login'
require_relative '../root/pages/banner'
require_relative '../root/pages/left_nav'
require_relative '../root/pages/notifications'
require_relative './pages/network_browse_drawer'
require_relative './pages/network_organizations'
require_relative './pages/network_navigation'

describe '[Network - Organizations - Browse Drawer]', :network, :app_client do
  include Login

  let(:banner) { Banner.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:network_browse_drawer) { NetworkBrowseDrawer.new(@driver) }
  let(:network_navigation) { NetworkNavigation.new(@driver) }
  let(:network_organizations) { NetworkOrganizations.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as cc user]') do
    before do
      log_in_as(Login::CC_HARVARD)
      left_nav.go_to_my_network
      network_navigation.go_to_org_tab
      expect(network_organizations.page_displayed?).to be_truthy
    end

    it 'shares provider details via text' do
      # UU3-49164 workaround for banner blocking drawer elements
      banner.dismiss_alert_if_displayed
      network_organizations.click_first_provider_row
      expect(network_browse_drawer.drawer_displayed?).to be_truthy

      network_browse_drawer.click_share_button
      expect(network_browse_drawer.share_form_displayed?).to be_truthy

      phone = Faker::PhoneNumber.cell_phone
      network_browse_drawer.share_provider_details_via_phone(phone)

      # because of Twilio validation on the phone number,
      # message may either send successfully or fail validation
      # either is a valid result for this e2e test
      notification_text = "";
      if notifications.success_banner_displayed?
        notification_text = notifications.success_text
      elsif notifications.error_banner_displayed?
        notification_text = notifications.error_text
      end

      expect(notification_text).to include(Notifications::MESSAGE_SENT)
        .or include(Notifications::PHONE_NUMBER_INVALID)

      network_browse_drawer.close_drawer
      expect(network_browse_drawer.drawer_not_displayed?).to be_truthy
    end
  end
end

require_relative '../auth/helpers/login_ehr'
require_relative './pages/network'
require_relative './pages/share_drawer'
require_relative '../root/pages/notifications_ehr'
require_relative '../../shared_components/base_page'
require_relative '../../shared_components/shares_page'
require_relative '../../../lib/mailtrap_helper'

describe '[Network] Share Providers', :ehr, :network, :share_drawer do
  include LoginEhr
  include MailtrapHelper

  let(:base_page) { BasePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:network) { Network.new(@driver) }
  let(:notifications) { NotificationsEhr.new(@driver) }
  let(:share_drawer) { ShareDrawer.new(@driver) }
  let(:shares_page) { SharesPage.new(@driver) }

  context('[as an EHR Network Directory user] using the Share drawer') do
    before do
      # user only has Network Directory permissions
      # so expect to land on the network page after login
      log_in_default_as(LoginEhr::NETWORK_DIRECTORY_USER)
      expect(network.page_displayed?).to be_truthy

      # set up vars
      @first_provider_name = network.first_provider_name
      @second_provider_name = network.second_provider_name
    end

    it 'can share a provider via SMS', :uuqa_400 do
      network.add_first_program
      network.click_share

      expect(share_drawer.page_displayed?).to be_truthy
      expect(share_drawer.provider_list_text).to include(@first_provider_name)
      expect(share_drawer.header_text).to eq('Share 1 Organization')

      # share to a valid phone number
      share_drawer.share_by_sms(ShareDrawer::VALID_PHONE_NUMBER)

      # verify "Message sent" notification
      notification_text = notifications.success_text
      expect(notification_text).to include(NotificationsEhr::MESSAGE_SENT)
      expect(network.drawer_closed?).to be_truthy
    end

    it 'can share a provider via email', :uuqa_401 do
      # use second program
      network.add_programs_by_index([1])

      network.click_share
      expect(share_drawer.page_displayed?).to be_truthy
      expect(share_drawer.provider_list_text).to include(@second_provider_name)
      expect(share_drawer.header_text).to eq('Share 1 Organization')

      email = 'test@test.com'
      share_drawer.share_by_email(email)

      # verify "Message sent" notification
      notification_text = notifications.success_text
      expect(notification_text).to include(NotificationsEhr::MESSAGE_SENT)
      expect(network.drawer_closed?).to be_truthy

      # check mailtrap:
      # adding a short wait so mailtrap can update
      sleep(10)
      network_name = 'QA-Carol Coordination Center with All Service Types'
      message = get_first_share_email(network: network_name, provider: @second_provider_name)

      # follow link to share page:
      share_link = get_share_link(message: message)
      @driver.get(share_link)
      expect(shares_page.page_displayed?).to be_truthy
      expect(shares_page.first_group_name).to include(@second_provider_name)
    end

    it 'can share a provider via print', :uuqa_402 do
      # add first and second programs:
      network.add_programs_by_index([0, 1])

      network.click_share

      expect(share_drawer.page_displayed?).to be_truthy
      expect(share_drawer.provider_list_text).to include(@first_provider_name, @second_provider_name)
      expect(share_drawer.header_text).to eq('Share 2 Organizations')

      share_drawer.share_by_print
      expect(network.drawer_closed?).to be_truthy

      # verify second window opens with share page
      expect(base_page.new_tab_opened?).to be_truthy
      expect(shares_page.page_title).to eq(SharesPage::TITLE)
    end
  end
end

# frozen_string_literal: true

require_relative './../pages/create_referral'
require_relative '../../auth/helpers/login'
require_relative '../../facesheet/pages/facesheet_header'
require_relative '../../root/pages/home_page'
require_relative '../../../shared_components/shares_page'

describe '[Referrals - External]', :app_client, :referrals do
  include Login

  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:share_drawer) { CreateReferral::ShareDrawer.new(@driver) }
  let(:shares_page) { SharesPage.new(@driver) }

  context('[as a Referral User]') do
    before(:each) do
      # since we're not creating or updating data on the client we can use a random, existing contact
      @contact = Setup::Data.random_existing_harvard_client

      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
    end

    context('creates OON referral to one provider and opens share drawer') do
      before(:each) do
        facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
        expect(facesheet_header.page_displayed?).to be_truthy

        facesheet_header.refer_client
        expect(add_referral_page.page_displayed?).to be_truthy

        oon_case_options = add_referral_page.add_oon_case_selecting_first_options(description: Faker::Lorem.sentence(word_count: 5))

        add_referral_page.click_share
        share_drawer.drawer_displayed?
        expect(share_drawer.provider_list).to include(oon_case_options[:recipients])
        expect(share_drawer.provider_header_count).to eq(1)
      end

      it 'shares external provider info via Print', :uuqa_367 do
        share_drawer.share_by_print
        expect(shares_page.new_tab_opened?).to be_truthy
        expect(shares_page.page_title).to eq(SharesPage::TITLE)
      end

      it 'toggles share options', :uuqa_1989 do
        share_drawer.click_share_method(method: 'email')
        expect(share_drawer.form_displayed?(method: 'email')).to be_truthy

        share_drawer.click_share_method(method: 'print')
        expect(share_drawer.form_displayed?(method: 'print')).to be_truthy

        share_drawer.click_share_method(method: 'text')
        expect(share_drawer.form_displayed?(method: 'text')).to be_truthy
      end
    end
  end
end

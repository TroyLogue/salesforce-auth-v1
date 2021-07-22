# frozen_string_literal: true

require_relative './../pages/create_referral'
require_relative '../../facesheet/pages/facesheet_header'
require_relative '../../root/pages/home_page'
require_relative '../../../shared_components/shares_page'

describe '[Referrals - External]', :app_client, :referrals do
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:share_drawer) { CreateReferral::ShareDrawer.new(@driver) }
  let(:shares_page) { SharesPage.new(@driver) }

  context('[as a Referral User]') do
    before(:each) do
      # since we're not creating or updating data on the client we can use a random, existing contact
      @contact = Setup::Data.random_existing_harvard_client

      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
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

# frozen_string_literal: true

require_relative '../../root/pages/home_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'
require_relative './../pages/referral'

describe '[Referrals]', :app_client, :referrals do
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:draft_referral_dashboard) { ReferralDashboard::Drafts.new(@driver) }
  let(:draft_referral) { Referral.new(@driver) }

  context('[as a Referral User]') do
    before do
      @contact = Setup::Data.create_yale_client_with_consent
      @contact.add_address # So that orgs display as opposed to a CC

      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_YALE)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy

      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client
    end

    it 'create a draft referral', :uuqa_1732 do
      expect(add_referral_page.page_displayed?).to be_truthy

      # Fill out referral info
      submitted_referral_options = add_referral_page.add_referral_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5)
      )
      add_referral_page.click_save_draft_button

      # User lands on draft dashboard page
      expect(draft_referral_dashboard.page_displayed?).to be_truthy

      # New created referral displays on dashboard
      draft_referral_dashboard.click_on_row_by_client_name(client: "#{@contact.fname} #{@contact.lname}")
      expect(draft_referral.page_displayed?).to be_truthy
      expect(draft_referral.referral_summary_info).to eq(submitted_referral_options)
    end
  end
end

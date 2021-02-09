# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/home_page'
require_relative '../../facesheet/pages/facesheet_header'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'
require_relative './../pages/referral'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:draft_referral_dashboard) { ReferralDashboard::Drafts.new(@driver) }
  let(:draft_referral) { Referral.new(@driver) }

  context('[as a Referral User]') do
    before{
      @contact = Setup::Data.create_yale_client_with_consent
      @contact.add_address # So that orgs display as opposed to a CC

      log_in_as(Login::ORG_YALE)
      expect(homepage.page_displayed?).to be_truthy
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id)
      facesheet_header.refer_client
    }

    it 'create a draft referral', :uuqa_1732 do
      expect(add_referral_page.page_displayed?).to be_truthy

      # Fill out referral info
      submitted_referral_options = add_referral_page.create_referral_selecting_first_options(
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

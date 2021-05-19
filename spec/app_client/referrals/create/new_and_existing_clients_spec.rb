# frozen_string_literal: true

require_relative '../../auth/helpers/login'
require_relative '../../root/pages/right_nav'
require_relative '../../root/pages/home_page'
require_relative '../../clients/pages/search_client_page'
require_relative '../../clients/pages/confirm_client_page'
require_relative '../../clients/pages/add_client_page'
require_relative '../../consent/pages/consent_modal'
require_relative './../pages/create_referral'
require_relative './../pages/referral_dashboard'

describe '[Referrals]', :app_client, :referrals do
  let(:homepage) { HomePage.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:add_referral_page) { CreateReferral::AddReferral.new(@driver) }
  let(:additional_info_page) { CreateReferral::AdditionalInfo.new(@driver) }
  let(:final_review_page) { CreateReferral::FinalReview.new(@driver) }
  let(:sent_referral_dashboard) { ReferralDashboard::Sent::All.new(@driver) }

  context('[as a Referral User]') do
    before {
      @auth_token = Auth.get_encoded_auth_token(email_address: Users::CC_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    # Changes from ES-60 cause delays in user indexing when using Search And Match
    # This test case can be re-evaluated once ES-110 has be investigated
    # The workaround is randomly select an already existing client that has already been indexed
    it 'user can create a referral for an existing client', :uuqa_1734, :es_110 do
      # Get a random existing contact

      @contact = Setup::Data.random_existing_harvard_client

      create_menu.start_new_referral
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @contact.fname, lname: @contact.lname, dob: @contact.dob_formatted)

      expect(confirm_client_page.page_displayed?).to be_truthy
      confirm_client_page.select_nth_client(index: 0)

      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @contact.fname,
        lname: @contact.lname,
        dob: @contact.dob_formatted
      )).to be_truthy
      add_client_page.save_client

      expect(add_referral_page.page_displayed?).to be_truthy
    end

    it 'user can create a referral for a new client', :uuqa_1735 do
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')

      create_menu.start_new_referral
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)

      # No clients should display they should be send directly to pre-filled form
      # But in the event of Faker returning the same data twice, we can create a new client
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?

      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(fname: fname, lname: lname, dob: dob)).to be_truthy
      add_client_page.save_client

      # User should land in referral page
      expect(add_referral_page.page_displayed?).to be_truthy
      submitted_referral_options = add_referral_page.add_referral_selecting_first_options(
        description: Faker::Lorem.sentence(word_count: 5)
      )
      add_referral_page.click_next_button

      # Adding if condition since page is optional
      additional_info_page.click_next_button if additional_info_page.page_displayed?

      expect(final_review_page.page_displayed?).to be_truthy
      expect(final_review_page.summary_info[0]).to eq(submitted_referral_options)
      final_review_page.click_submit_button

      # Since it is a new client we expect the consent modal to display before proceeding
      consent_modal.add_consent_by_document_upload
      expect(sent_referral_dashboard.page_displayed?).to be_truthy
    end
  end
end

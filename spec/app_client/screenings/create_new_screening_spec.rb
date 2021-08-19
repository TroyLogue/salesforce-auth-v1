# frozen_string_literal: true

require_relative './pages/new_screening_page'
require_relative './pages/screening_page'
require_relative './pages/create_referral_from_screening_page'
require_relative '../clients/pages/add_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../consent/pages/consent_modal'
require_relative '../clients/pages/search_client_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../referrals/pages/create_referral'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'

describe '[Screenings - Create New Screening]', :screenings, :app_client, :create_screenings do
  let(:home_page) { HomePage.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:new_screening_page) { NewScreeningPage.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:screening_page) { ScreeningPage.new(@driver) }
  let(:create_referral_from_screening_page) { CreateReferralFromScreeningPage.new(@driver) }
  let(:add_referral) { CreateReferral::AddReferral.new(@driver) }

  context('[as a user with Screening Role]') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::SCREENINGS_USER_MULTI_NETWORK)
      home_page.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(home_page.page_displayed?).to be_truthy
    end

    # TODO: deprecate with core consolidation; cover test concerns in core and front-end
    it 'user can create a screening with no referral needs for a new client', :uuqa_1770 do
      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      create_menu.start_new_screening
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)

      # No clients should display they should be send directly to pre-filled form
      # But in the event of Faker returning the same data twice, we can create a new client
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?

      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(fname: fname, lname: lname, dob: dob)).to be_truthy
      add_client_page.save_client
      expect(new_screening_page.page_displayed?).to be_truthy
      new_screening_page.complete_screening_with_no_referral_needs
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eq "#{fname} #{lname}"
      expect(screening_page.page_displayed?).to be_truthy
      expect(screening_page.no_needs_displayed?).to be_truthy
    end
  end

  context('[as a user with Screening Role]') do
    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      home_page.authenticate_and_navigate_to(token: auth_token, path: '/')
      create_menu.start_new_screening
      expect(search_client_page.page_displayed?).to be_truthy

      fname = Faker::Name.first_name
      lname = Faker::Name.last_name
      dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
      search_client_page.search_client(fname: fname, lname: lname, dob: dob)
      confirm_client_page.click_create_new_client if confirm_client_page.page_displayed?
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(fname: fname, lname: lname, dob: dob)).to be_truthy
      add_client_page.save_client
      expect(new_screening_page.page_displayed?).to be_truthy
    end

    it 'creates screening and identifies needs', :uuqa_299 do
      new_screening_page.submit_first_choices
      consent_modal.add_consent_by_document_upload
      expect(screening_page.needs_displayed? || screening_page.no_needs_displayed?).to be_truthy

      if screening_page.needs_displayed?
        needs_count = screening_page.selected_needs_count
        screening_page.click_create_referrals
        expect(create_referral_from_screening_page.page_displayed?).to be_truthy

        if needs_count == 1
          # when there is a single need the form should expanded
          expect(add_referral.service_form_expanded_count).to eq 1
          expect(add_referral.service_form_collapsed_count).to eq 0
        elsif needs_count > 1
          # when there are multiple needs all forms should be collapsed
          expect(add_referral.service_form_expanded_count).to eq 0
          expect(add_referral.service_form_collapsed_count).to eq needs_count
        else
          raise "E2E ERROR: needs_count was #{needs_count}, expected to be > 0; should not have passed screening_page.needs_displayed? which matches on a selected checkbox"
        end
      end
    end
  end
end

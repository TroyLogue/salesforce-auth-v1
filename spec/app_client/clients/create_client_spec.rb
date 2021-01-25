require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/notifications'
require_relative '../clients/pages/search_client_page'
require_relative '../clients/pages/confirm_client_page'
require_relative '../clients/pages/add_client_page'
require_relative '../facesheet/pages/facesheet_header'
require_relative '../consent/pages/consent_modal'

describe '[Dashboard - Client - Search]', :clients, :app_client do
  include Login

  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:create_menu) { RightNav::CreateMenu.new(@driver) }
  let(:search_client_page) { SearchClient.new(@driver) }
  let(:confirm_client_page) { ConfirmClient.new(@driver) }
  let(:add_client_page) { AddClient.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:consent_modal) { ConsentModal.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as a user in an NextGate org]') do
    before {
      log_in_as(Login::NEXTGATE_USER)
      expect(homepage.page_displayed?).to be_truthy
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
    }

    it 'Create a consented NextGate client', :uuqa_901, :uuqa_903 do
      # Start creation process by searching for non-existant client
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      # No clients should display they should be send directly to pre-filled form
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @fname,
        lname: @lname,
        dob: @dob)).to be_truthy

      # Save client, user should land on facesheet of newly created client and now search for client
      add_client_page.save_client
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
      notifications.close_banner

      # Client created on NG is now searchable
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      expect(confirm_client_page.page_displayed?).to be_truthy
      expect(confirm_client_page.clients_returned).to be(1)
      confirm_client_page.select_nth_client(index: 0)

      # And Info is again pre-filled correctly
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @fname,
        lname: @lname,
        dob: @dob)).to be_truthy
    end
  end

  context('[as cc user]') do
    before {
      log_in_as(Login::NEW_SEARCH_USER)
      expect(homepage.page_displayed?).to be_truthy
      @fname = Faker::Name.first_name
      @lname = Faker::Name.last_name
      @dob = Faker::Time.backward(days: 1000).strftime('%m/%d/%Y')
    }

    it 'Create a consented client', :uuqa_1300, :uuqa_1301 do
      # Start creation process by searching for non-existant client
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      # No clients should display they should be send directly to pre-filled form
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @fname,
        lname: @lname,
        dob: @dob)).to be_truthy

      # Save client, user should land on facesheet of newly created client and now search for client
      add_client_page.save_client
      consent_modal.add_consent_by_document_upload
      expect(facesheet_header.facesheet_name).to eql("#{@fname} #{@lname}")
      notifications.close_banner

      # Client is now searchable
      create_menu.start_new_client
      expect(search_client_page.page_displayed?).to be_truthy
      search_client_page.search_client(fname: @fname, lname: @lname, dob: @dob)

      expect(confirm_client_page.page_displayed?).to be_truthy
      expect(confirm_client_page.clients_returned).to be(1)
      confirm_client_page.select_nth_client(index: 0)

      # And Info is again pre-filled correctly
      expect(add_client_page.page_displayed?).to be_truthy
      expect(add_client_page.is_info_prefilled?(
        fname: @fname,
        lname: @lname,
        dob: @dob)).to be_truthy
    end
  end
end

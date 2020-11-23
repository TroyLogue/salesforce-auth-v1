# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/new_referral'
require_relative './pages/referrals_table'

describe '[Referrals]', :ehr, :referrals do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }

  context('[default view]') do
    before do
      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(new_referral.page_displayed?).to be_truthy
    end

    it 'can create a referral using provider add/remove buttons', :uuqa_1614 do
      # select Princeton and Columbia from table and enable auto-recall option
      # avoid sending new referrals to Yale and Harvard from EMR
      # to avoid conflicts with app-client tests
      providers = ["Princeton", "Columbia"]
      new_referral.create_referral

      # after sending referral, verify that the referrals table appears
      # verify the referral you just sent in the table?
    end

    it 'can create a referral using provider drawer', :uuqa_1615 do
      # select Princeton via provider drawer Add Button
    end
  end
end

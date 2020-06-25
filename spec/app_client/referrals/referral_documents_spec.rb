require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/dashboard_referral'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:new_referral) { Referral.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::CC_HARVARD)
      expect(homepage.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent(token: base_page.get_uniteus_api_token)

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(token: base_page.get_uniteus_api_token,
                                                                      contact_id: @contact.contact_id,
                                                                      service_type_id: base_page.get_uniteus_first_service_type_id)

      user_menu.log_out
      expect(login_email.page_displayed?).to be_truthy
      log_in_as(Login::ORG_PRINCETON)
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'user can add and remove document on a new referral', :uuqa_134, :uuqa_136 do
      new_referral.go_to_new_referral_with_id(referral_id: @referral.referral_id)
      @document = Faker::Alphanumeric.alpha(number: 8) + '.txt'

      new_referral.attach_document_to_referral(file_name: @document)
      expect(new_referral.document_list).to include(@document)

      new_referral.remove_document_from_referral(file_name: @document)
      expect(new_referral.no_documents?).to be_truthy
    end

    after {
      # accepting referral
      @accept_referral = Setup::Data.accept_referral_from_harvard_in_princeton(token: base_page.get_uniteus_api_token,
                                                                               referral_id: @referral.referral_id)
    }
  end
end

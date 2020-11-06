require_relative '../auth/helpers/login'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative '../referrals/pages/referral'

describe '[Referrals]', :app_client, :referrals do
  include Login

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:new_referral) { Referral.new(@driver) }

  context('[as org user]') do
    before {
      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(
        contact_id: @contact.contact_id
      )

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
      @accept_referral = Setup::Data.accept_referral_in_princeton(
        referral_id: @referral.referral_id
      )
    }
  end
end

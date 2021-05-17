require_relative './pages/facesheet_header'
require_relative './pages/facesheet_uploads_page'
require_relative '../referrals/pages/referral.rb'

describe '[Facesheet]', :app_client, :facesheet do
  let(:new_referral) { Referral.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_uploads_page) { FacesheetUploadsPage.new(@driver) }

  context('[as org user]') do
    before {
      # Auth Session
      @auth_token = Auth.get_encoded_auth_token(email_address: Users::ORG_PRINCETON)

      # Create Contact
      @contact = Setup::Data.create_harvard_client_with_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_harvard_to_princeton(
        contact_id: @contact.contact_id
      )

      # Navigate to referral and attach document
      new_referral_path = new_referral.path_of_new_referral_with_id(referral_id: @referral.id)
      new_referral.authenticate_and_navigate_to(token: @auth_token, path: new_referral_path)

      @document = Faker::Alphanumeric.alpha(number: 8) + '.txt'
      new_referral.attach_document_to_referral(file_name: @document)
      expect(new_referral.document_list).to include(@document)

      # Accept referral into a program
      new_referral.accept_action
    }

    it 'Rename resource document in uploads', :uuqa_341 do
      facesheet_header.go_to_facesheet_with_contact_id(id: @contact.contact_id, tab: 'uploads')
      facesheet_uploads_page.rename_document(current_file_name: @document, new_file_name: 'rename.txt')
      expect(facesheet_uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end
  end
end

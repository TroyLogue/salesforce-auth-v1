require_relative '../root/pages/notifications'
require_relative '../clients/pages/clients_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_uploads_page'

describe '[Facesheet]', :app_client, :facesheet do
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_uploads_page) { FacesheetUploadsPage.new(@driver) }
  let(:notifications) { Notifications.new(@driver) }

  context('[as org user]') do
    before do
      auth_token = Auth.encoded_auth_token(email_address: Users::ORG_COLUMBIA)
      clients_page.authenticate_and_navigate_to(token: auth_token, path: ClientsPage::ALL_CLIENTS_PATH)
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client

      # Uploading as part of set up
      facesheet_header.go_to_uploads
      @file = Faker::Alphanumeric.alpha(number: 8) + '.txt'

      facesheet_uploads_page.upload_document(file_name: @file)
      expect(notifications.success_text).to eq(Notifications::DOCUMENTS_SAVED)
      expect(facesheet_uploads_page.document_uploaded?(file_name: @file)).to be_truthy
    end

    it 'Rename client document in uploads', :uuqa_341 do
      facesheet_uploads_page.rename_document(current_file_name: @file, new_file_name: 'rename.txt')
      expect(facesheet_uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end

    it 'Remove client document in uploads', :uuqa_342 do
      facesheet_uploads_page.remove_document(file_name: @file)
      expect(facesheet_uploads_page.is_document_removed?(@file)).to be_truthy
    end

    after do
      facesheet_uploads_page.delete_documents
    end
  end
end

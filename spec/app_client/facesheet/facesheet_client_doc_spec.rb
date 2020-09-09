require_relative '../auth/helpers/login'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_uploads_page'

describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:left_nav) { LeftNav.new(@driver) }
  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_uploads_page) { FacesheetUploadsPage.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client

      # Uploading as part of set up
      facesheet_header.go_to_uploads
      @file = Faker::Alphanumeric.alpha(number: 8) + '.txt'
      expect(facesheet_uploads_page.upload_document(@file)).to be_truthy
    }

    it 'Rename client document in uploads', :uuqa_341 do
      facesheet_uploads_page.rename_document(current_file_name: @file, new_file_name: 'rename.txt')
      expect(facesheet_uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end

    it 'Remove client document in uploads', :uuqa_342 do
      facesheet_uploads_page.remove_document(@file)
      expect(facesheet_uploads_page.is_document_removed?(@file)).to be_truthy
    end

    after {
      facesheet_uploads_page.delete_documents
    }
  end
end

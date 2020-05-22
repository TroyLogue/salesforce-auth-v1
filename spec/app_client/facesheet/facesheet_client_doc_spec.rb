require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_uploads_page'

describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:left_nav) { LeftNav.new(@driver) }
  let(:clients_page) { ClientsPage.new(@driver) }
  let(:facesheet_page) { Facesheet.new(@driver) }
  let(:uploads_page) { Uploads.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_second_authorized_client

      #Uploading as part of set up
      facesheet_page.go_to_uploads
      @file = Faker::Alphanumeric.alpha(number: 8) + '.txt'
      expect(uploads_page.upload_document(@file)).to be_truthy
    }

    it 'Rename client document in uploads', :uuqa_341 do
      uploads_page.rename_document(current_file_name: @file, new_file_name: 'rename.txt')
      expect(uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end

    it 'Remove client document in uploads', :uuqa_342 do
      uploads_page.remove_document(@file)
      expect(uploads_page.is_document_removed?(@file)).to be_truthy
    end

    after {
      uploads_page.delete_documents
    }
  end
end

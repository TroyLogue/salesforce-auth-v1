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
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:uploads_page) { Uploads.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      left_nav.go_to_clients
      expect(clients_page.page_displayed?).to be_truthy
      clients_page.go_to_facesheet_first_authorized_client
    }
    #should not run until referrals are done
    it 'Rename resource document in uploads', :uuqa_341, :wip do
      facesheet_header.go_to_uploads
      uploads_page.rename_document(current_file_name: 'fakeConsent.txt', new_file_name: 'rename.txt')
      expect(uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end
  end
end

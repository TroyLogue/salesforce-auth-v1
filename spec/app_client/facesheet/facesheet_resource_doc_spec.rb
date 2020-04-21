require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../clients/pages/clients_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_uploads_page'
require_relative '../../../lib/data_creation'


describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }
  let(:uploads_page) { Uploads.new(@driver)}

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)

      #Creating Data
      contact = DataCreation::Contact.new
      contact_response = contact.create(token: base_page.get_uniteus_api_token, group_id: base_page.get_uniteus_group)

      #Going to Clients page
      search_bar.search_for(contact.searchable_name)
      search_bar.go_to_facesheet_of(contact.searchable_name)
    } 
    #should not run until referrals are done
    it 'Rename resource document in uploads', :uuqa_341, :wip do
        facesheet_header.go_to_uploads
        uploads_page.rename_document(current_file_name:'fakeConsent.txt', new_file_name:'rename.txt')
        expect(uploads_page.is_document_renamed?('rename.txt')).to be_truthy
    end 
  end
end

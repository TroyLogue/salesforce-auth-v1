require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative '../../../lib/setup_contacts'


describe '[Facesheet]', :app_client, :facesheet do
  include Login

  let(:login_email) {LoginEmail.new(@driver) }
  let(:login_password) {LoginPassword.new(@driver) }
  let(:base_page) { BasePage.new(@driver) }
  let(:homepage) { HomePage.new(@driver)}
  let(:search_bar) { RightNav::SearchBar.new(@driver) }
  let(:facesheet_header) { Facesheet.new(@driver) }

  context('[as org user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      expect(homepage.page_displayed?).to be_truthy

      #Creating Data
      @contact = Setup::Contact.new
      contact_response = @contact.create(token: base_page.get_uniteus_api_token, group_id: base_page.get_uniteus_group)
      expect(contact_response.status.to_s).to eq('201 Created')
      @contact.contact_id = JSON.parse(contact_response, object_class: OpenStruct).data.id
    } 

    it 'Rename resource document in uploads', :uuqa_341, :wip, :poc do
        facesheet_header.go_to_facesheet_with_contact_id(id:@contact.contact_id, tab:'profile')
        expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
    end 
  end
end

require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../root/pages/right_nav'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative '../../../lib/data_creation'


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
      @contact = DataCreation::Contact.new
      contact_response = @contact.create(token: base_page.get_uniteus_api_token, group_id: base_page.get_uniteus_group)

      # Going to remove this, but placing this for now because it takes a bit for a new client to be indexed into search
      # Since we will have the access to a clients id we can directly navigate to their facesheet
      print @contact.contact_id
      sleep(10) 

      #Going to Clients page
      search_bar.search_for(@contact.searchable_name)
      search_bar.go_to_facesheet_of(@contact.searchable_name)
    } 
    #should not run until referrals are done
    it 'Rename resource document in uploads', :uuqa_341, :wip, :poc do
        expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
    end 
  end
end

require_relative '../../spec_helper'
require_relative '../auth/helpers/login'
require_relative '../auth/pages/login_email'
require_relative '../auth/pages/login_password'
require_relative '../clients/pages/clients_page'
require_relative '../root/pages/home_page'
require_relative '../root/pages/left_nav'
require_relative'../facesheet/pages/facesheet_header'
require_relative '../intakes/pages/intake_page'
require_relative'../facesheet/pages/facesheet_forms_page'
require 'byebug'


describe '[Intake]', :app_client, :intake do
    include Login

    let(:login_email) { LoginEmail.new(@driver) }
    let(:login_password) { LoginPassword.new(@driver) }
    let(:base_page) { BasePage.new(@driver) }
    let(:clients_page) {ClientsPage.new(@driver)}
    let(:home_page) {HomePage.new(@driver)}
    let(:left_nav) { LeftNav.new(@driver) }
    let(:facesheet_forms_page) { FacesheetForms.new(@driver) }
    let(:facesheet_header) { FacesheetHeader.new(@driver) }
    let(:intake_page) {Intake.new(@driver)}
    let(:facesheet_profile_page) {FacesheetProfilePage.new(@driver)}

    context('[as org user]') do
        before {
          log_in_as(Login::ORG_YALE)
          expect(home_page.page_displayed?).to be_truthy
           

     # Create Contact
      @contact = Setup::Data.create_yale_client_with_consent(token: base_page.get_uniteus_api_token)
            }

      it 'can start and save intake', :uuqa_81, :uuqa_82 do
       
         facesheet_header.go_to_facesheet_with_contact_id(
              id: @contact.contact_id,
              tab: 'forms'
            )
             expect(facesheet_header.get_facesheet_name).to eql(@contact.searchable_name)
             expect(facesheet_forms_page.page_displayed?).to be_truthy

        # create new intake from facesheet form
        facesheet_forms_page.create_new_intake
         expect(intake_page.page_displayed?).to be_truthy
         expect(intake_page.is_info_prefilled?).to be_truthy

         #enter other information
         intake_page.select_other_information
         intake_page.select_marital_status
         intake_page.select_gender
         intake_page.select_race
         intake_page.select_ethnicity
         intake_page.select_citzenship
         intake_page.input_ssn

        # add intake note
        intake_page.add_note

        # "This client needs action" checkbox
        intake_page.check_checkbox

        #save intake
        intake_page.save_intake

        # verify green ribbon with the message "intake successfully created"
        expect(facesheet_header.green_ribbon_displayed?).to be_truthy
        expect(facesheet_header.assessments_displayed?).to be_truthy 
      

      end
    end
 end

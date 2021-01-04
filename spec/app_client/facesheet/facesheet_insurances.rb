require_relative '../../../lib/state_name_abbr'
require_relative '../auth/helpers/login'
require_relative '../root/pages/home_page'
require_relative './pages/facesheet_header'
require_relative './pages/facesheet_profile_page'
require_relative '../root/pages/left_nav'
require_relative '../clients/pages/clients_page'

describe '[Facesheet][Profile]', :app_client, :facesheet, :insurance do
  include Login

  let(:login_email) { LoginEmail.new(@driver) }
  let(:login_password) { LoginPassword.new(@driver) }
  let(:home_page) { HomePage.new(@driver) }
  let(:facesheet_header) { FacesheetHeader.new(@driver) }
  let(:facesheet_profile) { FacesheetProfilePage.new(@driver) }

  context('[as insurance user]') do
    before {
      log_in_as(Login::ORG_COLUMBIA)
      expect(home_page.page_displayed?).to be_truthy
      # Create Contact
      @contact = Setup::Data.create_columbia_client_with_consent
    }

    it 'User can add new insurance', :insurance do
      facesheet_header.go_to_facesheet_with_contact_id(
        id: @contact.contact_id,
        tab: 'profile'
      )

      aggregate_failures 'Add Medicare Plan' do
        # Add Medicare Insurance
        @plan_type = facesheet_profile.class::MEDICARE_PLAN
        @plan = facesheet_profile.class::MEDICARE_PLAN
        @member_id = Medicare.generate_id
        @group_id = Faker::Alphanumeric.alphanumeric(number: 5).upcase
        facesheet_profile.add_insurance(plan_type: @plan_type,
                                                insurance_plan: @plan,
                                                member_id: @member_id,
                                                group_id: @group_id)
        expect(facesheet_profile.list_insurances).to include(@plan_type, @plan, @member_id)

        # Add Medicaid Insurance
        @plan_type = facesheet_profile.class::MEDICAID_PLAN
        @plan = "Medicaid (AK)"
        @member_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
        @group_id = Faker::Alphanumeric.alphanumeric(number: 5).upcase
        facesheet_profile.add_insurance(plan_type: @plan_type,
                                                insurance_plan: @plan,
                                                member_id: @member_id,
                                                group_id: @group_id)
        expect(facesheet_profile.list_insurances).to include(@plan_type, @plan, @member_id, @group_id)

        # Add Commercial Insurance
        @plan_type = facesheet_profile.class::COMMERCIAL_PLAN
        @plan = "Accountability New Health"
        @member_id = Faker::Alphanumeric.alphanumeric(number: 10).upcase
        @group_id = Faker::Alphanumeric.alphanumeric(number: 5).upcase
        @coverage_start = '12/12/2020'
        @coverage_end = '12/12/1230'
        facesheet_profile.add_insurance(plan_type: @plan_type,
                                                insurance_plan: @plan,
                                                member_id: @member_id,
                                                group_id: @group_id,
                                                coverage_start: @coverage_start,
                                                coverage_end: @coverage_end)
        expect(facesheet_profile.list_insurances).to include(@plan, @member_id, @group_id, @coverage_start, @coverage_end)
      end
    end
  end

end

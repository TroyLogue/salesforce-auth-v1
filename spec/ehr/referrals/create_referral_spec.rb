# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative './pages/referral_assessment'
require_relative './pages/find_programs'
require_relative './pages/select_service_types'
require_relative './pages/add_description'
require_relative './pages/referral_review'
require_relative '../network/pages/program_drawer'

describe '[Referrals]', :ehr, :ehr_referrals do
  include LoginEhr

  let(:add_description) { AddDescription.new(@driver) }
  let(:find_programs) { FindPrograms.new(@driver) }
  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:program_drawer) { ProgramDrawer.new(@driver) }
  let(:referral_assessment) { ReferralAssessment.new(@driver) }
  let(:referral_review) { ReferralReview.new(@driver) }
  let(:select_service_types) { SelectServiceTypes.new(@driver) }

  context('[default view] User can create a referral') do
    before do
      @service_type = "Disability Benefits"

      log_in_default_as(LoginEhr::CC_HARVARD)
      expect(homepage.default_view_displayed?).to be_truthy

      homepage.go_to_create_referral
      expect(find_programs.page_displayed?).to be_truthy
    end

    it 'adding two programs via table', :uuqa_1614 do
      # select two random programs from table
      description = Faker::Lorem.sentence(word_count: 5)

      find_programs.select_service_type_by_text(@service_type)
      find_programs.add_programs_from_table(program_count: 2)
      find_programs.click_next
      expect(select_service_types.page_displayed?).to be_truthy

      select_service_types.select_random_service_type_for_each_referral
      select_service_types.click_next
      expect(add_description.page_displayed?).to be_truthy

      add_description.fill_out_description_card_for_each_referral(description: description)
      add_description.click_next
      referral_assessment.click_next if referral_assessment.page_displayed?
      expect(referral_review.page_displayed?).to be_truthy

      referral_review.complete_referral
      expect(homepage.default_view_displayed?).to be_truthy
    end

    # don't need to create whole referral, just confirm that the program
    # is added using the button from the drawer
    it 'adding a program using program drawer', :uuqa_1615 do
      description = Faker::Lorem.sentence(word_count: 5)

      find_programs.select_service_type_by_text(@service_type)
      find_programs.open_random_program_drawer
      expect(program_drawer.page_displayed?).to be_truthy
      program_drawer.add_program
      program_drawer.close_drawer
      find_programs.click_next
      expect(select_service_types.page_displayed?).to be_truthy

      # validate that the service types page contains the program name
    end
  end
end

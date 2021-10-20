# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page_ehr'
require_relative '../referrals/pages/find_programs'
require_relative './pages/new_screening'
require_relative './pages/screening'
require_relative './pages/screenings_table'

describe '[Screenings]', :ehr, :screenings do
  include LoginEhr

  let(:homepage) { HomePageEhr.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:find_programs) { FindPrograms.new(@driver) }
  let(:new_screening) { NewScreening.new(@driver) }
  let(:screening) { Screening.new(@driver) }
  let(:screenings_table) { ScreeningsTable.new(@driver) }

  context('[default view] as a screenings user in one network') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::SCREENINGS_USER)
      expect(homepage.default_view_displayed?).to be_truthy
      homepage.go_to_screenings_tab
      expect(screenings_table.page_displayed?).to be_truthy
    end

    it 'creates a screening with referral needs', :uuqa_580, :test do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_referral_needs
      expect(screening.page_displayed?).to be_truthy
      expect(screening.needs_identified?).to be_truthy

      service_type = screening.get_first_identified_service_type
      screening.create_referral_from_identified_need
      expect(find_programs.page_displayed?).to be_truthy
      expect(find_programs.selected_service_type).to include(service_type)
    end

    it 'creates a screening with no referral needs', :uuqa_581 do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_no_referral_needs
      expect(screening.page_displayed?).to be_truthy
      expect(screening.no_needs_identified?).to be_truthy
    end
  end

  context('[default view] as a screenings user in multiple networks') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::SCREENINGS_USER_MULTI_NETWORK)
      expect(homepage.default_view_displayed?).to be_truthy
      homepage.go_to_screenings_tab
      expect(screenings_table.page_displayed?).to be_truthy
    end

    it 'creates a screening with referral needs', :uuqa_1728, :test do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_referral_needs
      expect(screening.page_displayed?).to be_truthy
      expect(screening.needs_identified?).to be_truthy

      service_type = screening.get_first_identified_service_type
      screening.create_referral_from_identified_need
      expect(find_programs.page_displayed?).to be_truthy
      expect(find_programs.selected_service_type).to include(service_type)
    end
  end
end

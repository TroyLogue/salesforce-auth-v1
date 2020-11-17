# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../referrals/pages/new_referral'
require_relative './pages/new_screening'
require_relative './pages/screening'
require_relative './pages/screenings_table'

describe '[Screenings]', :ehr, :screenings do
  include LoginEhr

  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_referral) { NewReferral.new(@driver) }
  let(:new_screening) { NewScreening.new(@driver) }
  let(:screening) { Screening.new(@driver) }
  let(:screenings_table) { ScreeningsTable.new(@driver) }

  context('[default view] as a screenings user') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::SCREENINGS_USER)
      expect(screenings_table.page_displayed?).to be_truthy
    end

    it 'creates a screening with referral needs', :uuqa_580 do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_referral_needs
      expect(screening.page_displayed?).to be_truthy
      expect(screening.needs_identified?).to be_truthy

      service_type = screening.get_first_identified_service_type
      screening.create_referral_from_identified_need
      expect(new_referral.page_displayed?).to be_truthy
      expect(new_referral.selected_service_type).to include(service_type)
    end

    it 'creates a screening with no referral needs', :uuqa_581 do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_no_referral_needs
      expect(screening.page_displayed?).to be_truthy
      expect(screening.no_needs_identified?).to be_truthy
    end
  end
end

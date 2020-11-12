# frozen_string_literal: true

require_relative '../auth/helpers/login_ehr'
require_relative '../root/pages/home_page'
require_relative './pages/new_screening'
require_relative './pages/screening'
require_relative './pages/screenings_table'

describe '[Screenings]', :ehr, :screenings do
  include LoginEhr

  let(:homepage) { HomePage.new(@driver) }
  let(:login_email_ehr) { LoginEmailEhr.new(@driver) }
  let(:login_password_ehr) { LoginPasswordEhr.new(@driver) }
  let(:new_screening) { NewScreening.new(@driver) }
  let(:screenings_table) { ScreeningsTable.new(@driver) }

  context('[default view] as a screenings user') do
    before do
      # screenings only available w patient context (default view)
      log_in_default_as(LoginEhr::SCREENINGS_USER)
      expect(homepage.default_view_displayed?).to be_truthy
      expect(screenings_table.page_displayed?).to be_truthy
    end

    it 'creates a screening with referral needs', :uuqa_580 do
      screenings_table.create_screening
      expect(new_screening.page_displayed?).to be_truthy

      new_screening.complete_screening_with_referral_needs
      expect(screening.page_displayed?).to be_truthy
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

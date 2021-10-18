require_relative '../root/pages/home_page'
require_relative '../root/pages/right_nav'
require_relative './pages/assessment_page'
require_relative '../referrals/pages/referral'

describe '[Assessments - Referrals]', :assessments, :app_client do
  let(:homepage) { HomePage.new(@driver) }
  let(:user_menu) { RightNav::UserMenu.new(@driver) }
  let(:assessment) { Assessment.new(@driver) }
  let(:referral) { Referral.new(@driver) }

  # assessment data
  QUESTION_ONE_TEXT = Faker::Lorem.sentence(word_count: 5)
  QUESTION_TWO_TEXT = Faker::Lorem.sentence(word_count: 5)

  context('[as cc user] On a new incoming referral') do
    before {
      @assessment_form_values = [QUESTION_ONE_TEXT, QUESTION_TWO_TEXT]

      # Generate pending referral for CC user:
      @auth_token = Auth.encoded_auth_token(email_address: Users::ORG_01_USER)
      homepage.authenticate_and_navigate_to(token: @auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy

      # Create Contact
      @contact = Setup::Data.create_yale_client_with_military_and_consent

      # Create Referral
      @referral = Setup::Data.send_referral_from_yale_to_harvard(
        contact_id: @contact.contact_id
      )
      referral.go_to_sent_referral_with_id(referral_id: @referral.id)
      expect(referral.page_displayed?).to be_truthy

      @assessment = Setup::Data.get_referral_form_name_for_yale(
        referral_id: @referral.id
      )

      # Fill out assessment from referral context
      referral.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.is_not_filled_out?).to be_truthy
      assessment.edit_and_save(responses: @assessment_form_values)
      user_menu.log_out

      # Log in as CC user to view referral
      @cc_auth_token = Auth.encoded_auth_token(email_address: Users::CC_01_USER)
      homepage.authenticate_and_navigate_to(token: @cc_auth_token, path: '/')
      expect(homepage.page_displayed?).to be_truthy
    }

    it 'can view Military Information and an assessment', :uuqa_326, :uuqa_332 do
      referral.go_to_new_referral_with_id(referral_id: @referral.id)
      expect(referral.page_displayed?).to be_truthy
      referral.wait_for_intake_assessments
      expect(referral.military_assessment_displayed?).to be_truthy
      expect(referral.assessment_list).to include(@assessment)

      #check military information first
      referral.open_military_assessment
      expect(assessment.military_information_page_displayed?).to be_truthy
      assessment.click_back_button

      #click on assessment
      referral.open_assessment(assessment_name: @assessment)
      expect(assessment.page_displayed?).to be_truthy
      expect(assessment.header_text).to include(@assessment)

      # verify assessment responses were saved
      assessment_text = assessment.assessment_text
      @assessment_form_values.each do |value|
        expect(assessment_text).to include(value.to_s)
      end
    end

    after {
      # close referral as cc
      Setup::Data.close_referral_in_harvard(note: 'Data cleanup')
    }
  end
end

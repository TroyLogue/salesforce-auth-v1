require_relative './pages/consent'

describe '[Consent]', :consent do
  let(:base_page) { BasePage.new(@driver) }
  let(:consent) { Consent.new(@driver) }

  before {
    # set up contact:
    consent_token= Setup::Data.get_consent_token_for_new_harvard_client

    consent.get_consent_page(token: consent_token)
    expect(consent.page_displayed?).to be_truthy
  }

  it 'displays the consent agreement for a new user', :uuqa_1630 do
    expect(consent.consent_agreement_displayed?).to be_truthy
  end
end

# frozen_string_literal: true

require_relative '../cases/pages/case'

describe '[Payments]', :app_client, :payments do
  context('[as Payments User') do
    before do
      @auth_token = Auth.encoded_auth_token(email_address: Users::PAYMENTS_USER)
      # TODO: create a case for a client via API; navigate to the newly created case
    end
  end

  it 'adds a service', :demo do # TODO: add tag with payments reference if useful
    byebug
    p 'hey'
  end
end

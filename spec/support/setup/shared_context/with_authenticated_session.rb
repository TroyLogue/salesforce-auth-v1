# frozen_string_literal: true

require_relative '../helpers/auth'

RSpec.shared_context :with_authenticated_session do
  def get_encoded_auth_token(email_address:, password: Users::DEFAULT_PASSWORD)
    Auth.get_encoded_auth_token(email_address: email_address, password: password)
  end

end

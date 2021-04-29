# frozen_string_literal: true
require_relative '../helpers/auth'
require_relative '../identifiers/users'

module JWTTokens
  def self.cc_user
    Auth.access_token(email_address: Users::CC_USER)
  end

  def self.princeton
    Auth.access_token(email_address: Users::ORG_PRINCETON)
  end

  def self.yale
    Auth.access_token(email_address: Users::ORG_YALE)
  end

  def self.columbia
    Auth.access_token(email_address: Users::ORG_COLUMBIA)
  end
end

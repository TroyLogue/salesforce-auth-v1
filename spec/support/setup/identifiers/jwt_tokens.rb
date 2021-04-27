# frozen_string_literal: true
require_relative '../helpers/auth'
require_relative '../identifiers/users'

module JWTTokens
  @auth = Auth.new()

  def self.cc_user
    @auth.access_token(email_address: Users::CC_USER)
  end

  def self.princeton
    @auth.access_token(email_address: Users::ORG_PRINCETON)
  end

  def self.yale
    @auth.access_token(email_address: Users::ORG_YALE)
  end

  def self.columbia
    @auth.access_token(email_address: Users::ORG_COLUMBIA)
  end
end

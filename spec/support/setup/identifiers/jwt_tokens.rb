# frozen_string_literal: true
require_relative '../helpers/auth'
require_relative '../identifiers/users'

module JWTTokens
  CC_HARVARD = ENV['CC_HARVARD_TOKEN'] # harvard@auto
  ORG_ATLANTA = ENV['ORG_ATLANTA_TOKEN'] # atlanta@auto.com
  ORG_COLUMBIA = ENV['ORG_COLUMBIA_TOKEN'] # columbia@auto.com
  ORG_NEWYORK = ENV['ORG_NEWYORK_TOKEN'] # newyork@auto.com
  ORG_PRINCETON = ENV['ORG_PRINCETON_TOKEN'] # princeton@auto.com
  ORG_YALE = ENV['ORG_YALE_TOKEN'] # yale@auto.com

  @auth = Auth.new()
  @cc_user = @auth.access_token(email_address: Users::CC_USER)
  @princeton = @auth.access_token(email_address: Users::ORG_PRINCETON)
  @yale = @auth.access_token(email_address: Users::ORG_YALE)
  @columbia = @auth.access_token(email_address: Users::ORG_COLUMBIA)

  def self.cc_user
    @cc_user
  end

  def self.princeton
    @princeton
  end

  def self.yale
    @yale
  end

  def self.columbia
    @columbia
  end
end

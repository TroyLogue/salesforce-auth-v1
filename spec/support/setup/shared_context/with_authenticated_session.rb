# frozen_string_literal: true

require_relative '../../../app_client/auth/helpers/login'

RSpec.shared_context :with_authenticated_session do
  def get_encoded_auth_token(email_address:, password: Login::DEFAULT_PASSWORD)
    are_environment_vars_set?
    csrf_auth = load_auth_and_csrf_tokens
    auth_cookie = get_auth_cookie(email_address: email_address, password: password, tokens: csrf_auth)
    code = set_auth_code(auth_cookie: auth_cookie)
    access_token = get_access_token(code: code)
    encode_access_token(token: access_token)
  end

  private

  def are_environment_vars_set?
    unless ENV['app_client_client_id'] && ENV['web_url'] && ENV['auth_url']
      raise("An environment variable is not set \n
            app_client_client_id: #{ENV['app_client_client_id']} \n
            web_url: #{ENV['web_url']} \n
            auth_url: #{ENV['auth_url']} \n ")
    end
  end

  def load_auth_and_csrf_tokens
    callback_path = "/oauth2/auth?client_id=#{ENV['app_client_client_id']}&redirect_uri=#{ENV['web_url']}/callback&scope=app:read%20app:write&response_type=code"

    initial_login = HTTParty.get("#{ENV['auth_url']}#{callback_path}")
    csrf_token = Nokogiri::HTML(initial_login.body).css('meta[name="csrf-token"]')[0]['content']
    auth_cookie = initial_login.headers['set-cookie'].split(';')[0]

    { csrf: csrf_token, auth: auth_cookie }
  end

  def get_auth_cookie(email_address:, password: , tokens:)
    parameters = {
      'authenticity_token': tokens[:csrf],
      'app_2_user[email]': email_address,
      'app_2_user[password]': password,
      'commit': 'Sign in'
    }

    response = HTTParty.post(
      "#{ENV['auth_url']}/login",
      query: parameters,
      headers: { 'cookie': tokens[:auth] },
      follow_redirects: false
    )
    expect(response.code).to eq(302)

    { auth: response.headers['set-cookie'] }
  end

  def set_auth_code(auth_cookie:)
    callback_path = "/oauth2/auth?client_id=#{ENV['app_client_client_id']}&redirect_uri=#{ENV['web_url']}/callback/&scope=app:read%20app:write&response_type=code"

    response = HTTParty.get(
      "#{ENV['auth_url']}#{callback_path}",
      headers: { 'cookie': auth_cookie[:auth] },
      follow_redirects: false
    )
    expect(response.code).to eq(302)

    query_values = URI(response.headers['location']).query
    { code: URI.decode_www_form(query_values).to_h['code'] }
  end

  def get_access_token(code:)
    body = {
      'client_id': ENV['app_client_client_id'],
      'redirect_uri': "#{ENV['web_url']}/callback/",
      'grant_type': 'authorization_code',
      'code': code[:code]
    }

    response = HTTParty.post("#{ENV['auth_url']}/oauth2/token", body: body)
    expect(response.code).to eq(200)

    response.body
  end

  def encode_access_token(token:)
    { name: 'uniteusApiToken', value: "{#{CGI.escape(token[1..-2]).gsub("%3A", ":").gsub("+","%20")}}" }
  end
end

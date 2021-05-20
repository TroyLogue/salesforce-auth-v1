# frozen_string_literal: true

class Auth
  class << self
    def jwt(email_address:, password: Users::DEFAULT_PASSWORD)
      # returns only a string of the JWT
      response_body = auth_token(email_address: email_address, password: password)
      parsed_response = JSON.parse response_body, symbolize_names: true
      parsed_response[:access_token]
    end

    def encoded_auth_token(email_address:, password: Users::DEFAULT_PASSWORD)
      # returns the whole token object, encoded to be added to browser cookies
      encode_token(token: auth_token(email_address: email_address, password: password))
    end

    private
    def are_environment_vars_set?
      unless ENV['app_client_client_id'] && ENV['web_url'] && ENV['auth_url'] && ENV['DEFAULT_PASSWORD']
        raise("An environment variable is not set \n
              app_client_client_id: #{ENV['app_client_client_id']} \n
              web_url: #{ENV['web_url']} \n
              auth_url: #{ENV['auth_url']} \n
              default_password: #{ENV['DEFAULT_PASSWORD']} \n")
      end
    end

    def encode_token(token:)
      { name: 'uniteusApiToken', value: "{#{CGI.escape(token[1..-2]).gsub("%3A", ":").gsub("+","%20")}}" }
    end

    def load_auth_and_csrf_tokens
      callback_path = "/oauth2/auth?client_id=#{ENV['app_client_client_id']}&redirect_uri=#{ENV['web_url']}/callback&scope=app:read%20app:write&response_type=code"

      initial_login = HTTParty.get("#{ENV['auth_url']}#{callback_path}")
      csrf_token = Nokogiri::HTML(initial_login.body).css('meta[name="csrf-token"]')[0]['content']
      auth_cookie = initial_login.headers['set-cookie'].split(';')[0]

      { csrf: csrf_token, auth: auth_cookie }
    end

    def get_auth_cookie(email_address:, password: , tokens:)
      # for now, set app_2 or app_1 based on environment variable
      domain = ENV['environment'].split('_')[-1]
      app_param = (domain == 'staging') ? 'app_2' : 'app_1'

      parameters = {
        'authenticity_token': tokens[:csrf],
        "#{app_param}_user[email]": email_address,
        "#{app_param}_user[password]": password,
        'commit': 'Sign in'
      }

      response = HTTParty.post(
        "#{ENV['auth_url']}/login",
        query: parameters,
        headers: { 'cookie': tokens[:auth] },
        follow_redirects: false
      )
      raise("Response returned: #{response.code}") unless response.code == 302

      { auth: response.headers['set-cookie'] }
    end

    def set_auth_code(auth_cookie:)
      callback_path = "/oauth2/auth?client_id=#{ENV['app_client_client_id']}&redirect_uri=#{ENV['web_url']}/callback/&scope=app:read%20app:write&response_type=code"

      response = HTTParty.get(
        "#{ENV['auth_url']}#{callback_path}",
        headers: { 'cookie': auth_cookie[:auth] },
        follow_redirects: false
      )
      raise("Response returned: #{response.code}") unless response.code == 302

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
      raise("Response returned: #{response.code}") unless response.code == 200

      response.body
    end

    def auth_token(email_address:, password: Users::DEFAULT_PASSWORD)
      # returns the whole token object, including expiration, scope, etc
      are_environment_vars_set?
      csrf_auth = load_auth_and_csrf_tokens
      auth_cookie = get_auth_cookie(email_address: email_address, password: password, tokens: csrf_auth)
      code = set_auth_code(auth_cookie: auth_cookie)
      get_access_token(code: code)
    end
  end
end

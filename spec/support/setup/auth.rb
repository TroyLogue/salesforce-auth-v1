# frozen_string_literal: true

class Auth
  class << self
    # create new nested hash that can adjust with new emails
    @@cached_jwt ||= Hash.new { |hash, key| hash[key] = {} }

    def jwt(email_address:, password: Users::DEFAULT_PASSWORD)
      # returns only a string of the JWT
      unless session_valid?(token: @@cached_jwt[email_address]["jwt"])
        # puts "Invalid jwt session. Clearing stored token for #{email_address}"
        @@cached_jwt[email_address].clear()
      end

      if (@@cached_jwt[email_address]["jwt"].nil? || @@cached_jwt[email_address]["jwt"].empty?)
        response_body = auth_token(email_address: email_address, password: password)
        parsed_response = JSON.parse response_body, symbolize_names: true
        # puts "caching jwt- #{email_address}"
        @@cached_jwt[email_address]["jwt"] = parsed_response[:access_token]
      else
        # puts "cached jwt - #{email_address}: #{@@cached_jwt[email_address]["jwt"]}"
       @@cached_jwt[email_address]["jwt"]
      end
    end

    def encoded_auth_token(email_address:, password: Users::DEFAULT_PASSWORD)
      # returns the whole token object, encoded to be added to browser cookies
      encode_token(token: auth_token(email_address: email_address, password: password))
    end

    private
    def are_environment_vars_set?
      unless ENV['APP_CLIENT_CLIENT_ID'] && ENV['APP_CLIENT_URL'] && ENV['APP_CLIENT_AUTH_URL'] && ENV['DEFAULT_PASSWORD']
        raise("An environment variable is not set \n
              app_client_client_id: #{ENV['APP_CLIENT_CLIENT_ID']} \n
              app_client_url: #{ENV['APP_CLIENT_URL']} \n
              app_client_auth_url: #{ENV['APP_CLIENT_AUTH_URL']} \n
              default_password: #{ENV['DEFAULT_PASSWORD']} \n")
      end
    end

    def encode_token(token:)
      { name: 'uniteusApiToken', value: "{#{CGI.escape(token[1..-2]).gsub("%3A", ":").gsub("+","%20")}}" }
    end

    def load_auth_and_csrf_tokens
      callback_path = "/oauth2/auth?client_id=#{ENV['APP_CLIENT_CLIENT_ID']}&redirect_uri=#{ENV['APP_CLIENT_URL']}/callback&scope=app:read%20app:write&response_type=code"

      initial_login = HTTParty.get("#{ENV['APP_CLIENT_AUTH_URL']}#{callback_path}")
      csrf_token = Nokogiri::HTML(initial_login.body).css('meta[name="csrf-token"]')[0]['content']
      auth_cookie = initial_login.headers['set-cookie'].split(';')[0]

      { csrf: csrf_token, auth: auth_cookie }
    end

    def get_auth_cookie(email_address:, password:, tokens:)
      # for now, set app_2 or app_1 based on environment variable
      if ['staging', 'devqa'].include? ENV['ENVIRONMENT']
        app_param = 'app_2'
      else
        app_param = 'app_1'
      end

      parameters = {
        'authenticity_token': tokens[:csrf],
        "#{app_param}_user[email]": email_address,
        "#{app_param}_user[password]": password,
        'commit': 'Sign in'
      }

      response = HTTParty.post(
        "#{ENV['APP_CLIENT_AUTH_URL']}/login",
        query: parameters,
        headers: { 'cookie': tokens[:auth] },
        follow_redirects: false
      )
      raise("Response returned: #{response.code} \nCheck app_client_client_id is correct: #{ENV['APP_CLIENT_CLIENT_ID']}") unless response.code == 302

      { auth: response.headers['set-cookie'] }
    end

    def set_auth_code(auth_cookie:)
      callback_path = "/oauth2/auth?client_id=#{ENV['APP_CLIENT_CLIENT_ID']}&redirect_uri=#{ENV['APP_CLIENT_URL']}/callback/&scope=app:read%20app:write&response_type=code"

      response = HTTParty.get(
        "#{ENV['APP_CLIENT_AUTH_URL']}#{callback_path}",
        headers: { 'cookie': auth_cookie[:auth] },
        follow_redirects: false
      )
      raise("#{response.request.last_uri} returned: #{response.code}") unless response.code == 302

      query_values = URI(response.headers['location']).query
      { code: URI.decode_www_form(query_values).to_h['code'] }
    end

    def get_access_token(code:)
      body = {
        'client_id': ENV['APP_CLIENT_CLIENT_ID'],
        'redirect_uri': "#{ENV['APP_CLIENT_URL']}/callback/",
        'grant_type': 'authorization_code',
        'code': code[:code]
      }

      response = HTTParty.post("#{ENV['APP_CLIENT_AUTH_URL']}/oauth2/token", body: body)
      raise("#{response.request.last_uri} returned: #{response.code}") unless response.code == 200

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

    def session_valid?(token:)
      #checks response for non 401 code
      response = HTTParty.get("#{ENV['API_URL']}/v3/groups/#{Providers::GENERAL_CC_01}", headers: { 'Authorization' => "Bearer #{token}", 'Content-Type' => 'application/json' })
      response.code == 200
    end
  end
end

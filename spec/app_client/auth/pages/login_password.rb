require_relative '../../../shared_components/base_page'

class LoginPassword < BasePage

  FORGOT_PASSWORD_LINK = { css: '#forgot-password-link' }
  NOT_YOU_LINK = { css: '#not-you-link' }
  PASSWORD_INPUT = { css: '#app_2_user_password' }
  SUBMIT_BUTTON = { css: 'input[value="Sign In"]' } 
  USER_EMAIL = { css: '#user-email' }

  # string to pass to enter_via_js which uses getElementById
  PASSWORD_INPUT_ID = 'app_2_user_password'

  def page_displayed?
    is_displayed?(FORGOT_PASSWORD_LINK)
    is_displayed?(NOT_YOU_LINK)
    is_displayed?(USER_EMAIL)
    is_displayed?(PASSWORD_INPUT)
  end

  def submit(password)
    find(PASSWORD_INPUT)

    # js scripts are used with the dynamic login form to avoid race conditions
    enter_via_js(password, PASSWORD_INPUT_ID) 
    click_via_js(SUBMIT_BUTTON)
  end 
  
end

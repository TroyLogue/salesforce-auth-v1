require_relative '../../../shared_components/base_page'

class LoginEmail < BasePage

  COVER_IMAGE = { css: '.cover-image' }

  AUTH_FORM = { css: '#auth-form-container' }
  EMAIL_INPUT = { css: '#user_email' }
  NEXT_BUTTON = { css: 'input[value="Next"]' }

  def page_displayed?
    is_displayed?(AUTH_FORM)
    is_displayed?(EMAIL_INPUT)
  end

  def submit(address)
    click(EMAIL_INPUT)
    enter(address, EMAIL_INPUT)
    click(NEXT_BUTTON)
  end 

end

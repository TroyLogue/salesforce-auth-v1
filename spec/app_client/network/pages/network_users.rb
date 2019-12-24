require_relative '../../../shared_components/base_page'

class NetworkUsers < BasePage 
    
  USERS_TABLE = { css: '.network__content-children tr:nth-of-type(2)' } # ported from ui-tests; may be meant to click the first user row; if yes, rename constant
  
end
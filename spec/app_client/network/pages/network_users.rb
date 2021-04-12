require_relative '../../../shared_components/base_page'

class NetworkUsers < BasePage
  USERS_TABLE = { css: '.network-directory__table' }
  USERS_SEARCH_BOX = { css: '#search-text' }
  USER_NAME_LIST = { css: '.user-row > td.name' }.freeze
  USER_EMAIL_LIST = { css: '.user-row > td.email > a' }.freeze
  USER_ROW_FIRST = { css: '.user-row:nth-of-type(1)' }.freeze

  def page_displayed?
    is_displayed?(USERS_TABLE)
  end

  def search_for(text)
    enter(text, USERS_SEARCH_BOX)
  end

  def no_users_displayed?
    is_not_displayed?(USER_ROW_FIRST)
  end

  def matching_users_displayed?(text)
    names_and_emails = get_list_of_user_names.zip(get_list_of_user_emails)
    users_displayed? && names_and_emails.all? { |name_and_email| name_and_email.any? { |val| val.include?(text) } }
  end

  def users_displayed?
    is_displayed?(USER_ROW_FIRST)
  end

  private

  def get_list_of_user_names
    names = find_elements(USER_NAME_LIST)
    names.collect(&:text)
  end

  def get_list_of_user_emails
    emails = find_elements(USER_EMAIL_LIST)
    emails.collect(&:text)
  end
end

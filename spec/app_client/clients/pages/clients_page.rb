require_relative '../../../shared_components/base_page'

class ClientsPage < BasePage
  AUTHORIZED_CLIENTS = { css: '.ui-table-body > tr:not(.unauthorized)' }
  FILTER_BAR = { css: '.filter-bar' }
  FILTER_SELECTION = { css: 'button[name="%s"]' }
  CLIENT_TABLE = { css: '.dashboard-inner-content' }
  CLIENT_NAME_LIST = { css: 'tr[id^="all-clients-table-row"] > td:nth-child(2) > span' }
  CLIENT_FIRST_AUTHORIZED = { css: '.ui-table-body > tr:not(.unauthorized):nth-child(1) > td' }
  CLIENT_SECOND_AUTHORIZED = { css: '.ui-table-body > tr:not(.unauthorized):nth-child(2) > td' }

  def page_displayed?
    is_displayed?(FILTER_BAR)
    wait_for_spinner
  end

  def click_filter_lastname_letter(letter)
    click(FILTER_SELECTION.transform_values { |v| v % letter })
    wait_for_spinner
  end

  def get_client_name_list
    names = find_elements(CLIENT_NAME_LIST)
    names_array = names.collect(&:text)
  end

  def go_to_facesheet_first_authorized_client
    authorized_clients[0].click
  end

  def go_to_facesheet_second_authorized_client
    authorized_clients[1].click
    wait_for_spinner
  end

  def go_to_facesheet_random_authorized_client
    authorized_clients.sample.click
  end

  private
  def authorized_clients
    find_elements(AUTHORIZED_CLIENTS)
  end
end

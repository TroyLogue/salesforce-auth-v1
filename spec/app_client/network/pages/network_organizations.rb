require_relative '../../../shared_components/base_page'

class NetworkOrganizations < BasePage

  # filters
  SERVICE_TYPE_FILTER = { css: '#service-type-filter' }
  SERVICE_TYPE_FILTER_ORG = { css: '#service-type-filter' }
  NETWORK_FILTER = { css: '#network-filter' }
  NETWORK_FILTER_ORG = { css: '#network-filter' }
  NETWORK_SCOPE_FILTER = { css: '#network-scope-filter' }

  # providers list
  NETWORK_OPT_FIRST = { css: '.network-menu-0' }
  TABLE_OPT_FIRST = { css: '#network-group-row-0' }
  ORG_TAB_GROUP_OPT_FIRST = { css: '#network-group-row-0' }
  OUT_OF_NETWORK_ORG = { css: '.ui-table-row-column span[data-tooltip="Out of Network Organization"]' }
  OON_LOGO = { css: '#OON-icon:nth-of-type(1)' }

  # ported from ui-tests, unclear which page they belong tp
  EDIT_BTN = { css: '#network-groups-drawer-edit-btn' }
  PHONE_NUMBER = { css: '#phone-number-main-field' }
  SAVE_BTN = { css: '#oon-group-form-save-btn' }
end

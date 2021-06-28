# frozen-string-literal: true

# parent service type ids can be dynamically fetched using these constants and the service_type_id method
# in support/setup/base/service_types.rb
module ServiceTypeCodes
  EMPLOYMENT = 'UU-EMPLOYMENT'
  FOOD_ASSISTANCE = 'UU-FOOD'
  SUBSTANCE_USE = 'UU-SUBSTANCE-USE' # sensitive
  TRANSPORTATION = 'UU-TRANSPORTATION'
  WELLNESS = 'UU-WELLNESS'
end

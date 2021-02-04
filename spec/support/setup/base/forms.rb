module Setup
  class Forms
    class << self
      def get_all_forms_for_case(token:, group_id:, contact_id:, case_id:)
        forms_response = Requests::Forms.get_all_for_case(token: token, group_id: group_id, contact_id: contact_id, case_id: case_id)
        parsed_forms_response = JSON.parse(forms_response, object_class: OpenStruct).data
      end

      def get_first_form_name_for_case(token:, group_id:, contact_id:, case_id:)
        get_all_forms_for_case(
          token: token,
          group_id: group_id,
          contact_id: contact_id,
          case_id: case_id
        ).first.form.name
      end

      def get_all_forms_for_referral(token:, group_id:, referral_id:)
        forms_response = Requests::Forms.get_all_for_referral(token: token, group_id: group_id, referral_id: referral_id)
        parsed_forms_response = JSON.parse(forms_response, object_class: OpenStruct).data
      end

      def get_first_form_name_for_referral(token:, group_id:, referral_id:)
        get_all_forms_for_referral(
          token: token,
          group_id: group_id,
          referral_id: referral_id
        ).first.form.name
      end
    end
  end
end

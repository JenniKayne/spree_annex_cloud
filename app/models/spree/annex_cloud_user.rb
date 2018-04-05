module Spree
  class AnnexCloudUser < Spree::Base
    include Spree::AnnexCloudUser::Api
    belongs_to :user

    def add_points(points, params = {})
      request_params = params.merge(
        action_id: 100,
        action_use: 4,
        earned_points: points
      )
      annex_cloud_post(api_userpoints_url, request_params)
    end

    def annex_cloud_resource
      @annex_cloud_resource ||= annex_cloud_get(api_user_url) if email.present?
    end

    def self.annex_cloud_resource_by_email(custom_email)
      class_instance = new
      class_instance.annex_cloud_get class_instance.api_user_url_by_email(custom_email)
    end

    def available_points
      annex_cloud_resource.blank? ? 0 : annex_cloud_resource[:available_points].to_i
    end

    def register
      params = {
        first_name: user.firstname,
        last_name: user.lastname,
        birth_date: (user.birthday.strftime('%Y-%m-%d') unless user.birthday.nil?)
      }

      response = annex_cloud_post(api_user_url, params)
      if response.present?
        update(annex_cloud_id: response['id'])
      elsif response == false
        # Probably user already registered
        user.annex_cloud_register_try
      end
      annex_cloud_id
    end

    def registered?
      annex_cloud_id.present?
    end
  end
end

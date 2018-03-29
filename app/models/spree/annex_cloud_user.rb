module Spree
  class AnnexCloudUser < Spree::Base
    include Spree::AnnexCloudUser::Api
    belongs_to :user

    def annex_cloud_resource
      @annex_cloud_resource ||= annex_cloud_get(api_user_url) if email.present?
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
      update(annex_cloud_id: response['id']) if response.present?
      annex_cloud_id
    end
  end
end

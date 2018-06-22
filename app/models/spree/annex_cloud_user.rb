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
      clear_cache
      annex_cloud_post(api_userpoints_url, request_params)
    end

    def annex_cloud_resource
      @annex_cloud_resource ||= annex_cloud_get(api_user_url) if email.present?
    end

    def clear_cache
      Rails.cache.delete("annex_cloud/user/available_points/#{user_id}")
      Rails.cache.delete("annex_cloud/user/tier/#{user_id}")
    end

    def self.annex_cloud_resource_by_email(custom_email)
      class_instance = new
      class_instance.annex_cloud_get class_instance.api_user_url_by_email(custom_email)
    end

    def self.annex_cloud_opt_in_by_email(custom_email)
      class_instance = new
      class_instance.annex_cloud_get class_instance.api_opt_in_url_by_email(custom_email)
    end

    def available_points
      @available_points ||= Rails.cache.fetch("annex_cloud/user/available_points/#{user_id}", expires_in: 1.hour) do
        annex_cloud_resource.blank? ? 0 : annex_cloud_resource[:available_points].to_i
      end
    end

    def register(params = {})
      register_params = {
        first_name: user.firstname,
        last_name: user.lastname,
        birth_date: (user.birthday.strftime('%Y-%m-%d') unless user.birthday.nil?)
      }.merge(params)

      response = annex_cloud_post(api_user_url, register_params)
      if response.present?
        update(annex_cloud_id: response['id'])
        update_opt_in if params[:opt_in].present?
      elsif response == false
        # Probably user already registered
        user.annex_cloud_register_try
      end
      annex_cloud_id
    end

    def registered?
      annex_cloud_id.present?
    end

    def tier
      return if email.blank?
      @tier ||= Rails.cache.fetch("annex_cloud/user/tier/#{user_id}", expires_in: 1.hour) do
        resource = annex_cloud_get(api_tier_url)
        resource[:current_tier] if resource.present?
      end
    end

    def update_opt_in
      annex_cloud_put(api_opt_in_url, status: 1).present?
    end

    def update_resource
      params = {
        first_name: user.firstname,
        last_name: user.lastname,
        birth_date: (user.birthday.strftime('%Y-%m-%d') unless user.birthday.nil?)
      }
      annex_cloud_put(api_user_url, params).present?
    end
  end
end

module Spree
  class AnnexCloudUser < Spree::Base
    module Api
      def annex_cloud_get(url, params = {})
        response = HTTParty.get url, query: params.merge(access_token: SpreeAnnexCloud.configuration.access_token)
        return if response.blank?
        if response['error_code'] == '0'
          response['data'].present? ? response['data'].with_indifferent_access : response.with_indifferent_access
        else
          false
        end
      rescue StandardError
        nil
      end

      def api_opt_in_url_by_email(custom_email)
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/userstatus/#{SpreeAnnexCloud.configuration.site_id}/#{custom_email}"
      end

      def api_user_url_by_email(custom_email)
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/user/#{SpreeAnnexCloud.configuration.site_id}/#{custom_email}"
      end

      def annex_cloud_post(url, params = {})
        response = HTTParty.post url, query: { access_token: SpreeAnnexCloud.configuration.access_token }, body: params
        return if response.blank?

        response['error_code'] == '0' ? response : false
      rescue StandardError
        nil
      end

      def annex_cloud_put(url, params = {})
        response = HTTParty.put url, query: { access_token: SpreeAnnexCloud.configuration.access_token }, body: params
        return if response.blank?

        response['error_code'] == '0' ? response : false
      rescue StandardError
        nil
      end

      def api_opt_in_url
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/userstatus/#{SpreeAnnexCloud.configuration.site_id}/#{email}"
      end

      def api_user_url
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/user/#{SpreeAnnexCloud.configuration.site_id}/#{email}"
      end

      def api_userpoints_url
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/userpoints/#{SpreeAnnexCloud.configuration.site_id}/#{email}"
      end

      def api_tier_url
        "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/lifetimepointsusertier/#{SpreeAnnexCloud.configuration.site_id}/#{email}"
      end
    end
  end
end

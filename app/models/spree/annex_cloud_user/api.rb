module Spree
  class AnnexCloudUser < Spree::Base
    module Api
      ANNEX_CLOUD_API_BASE_URL ||= 'https://s15.socialannex.net/api'

      def annex_cloud_resource
        @annex_cloud_resource ||= annex_cloud_get(api_user_url) if email.present?
      end

      private

      def annex_cloud_get(url, params = {})
        response = HTTParty.get url, query: params.merge(access_token: SpreeAnneCloud.Configuration.access_token)
        if response.present? && response['errorcode'] == '0'
          response['data'].present? ? response['data'].with_indifferent_access : true
        end
      end

      def annex_cloud_post(url, params = {})
        HTTParty.post url, query: params.merge(access_token: SpreeAnneCloud.Configuration.access_token)
      end

      def api_user_url
        "#{ANNEX_CLOUD_API_BASE_URL}/#{SpreeAnneCloud.Configuration.site_id}/#{email}"
      end
    end
  end
end

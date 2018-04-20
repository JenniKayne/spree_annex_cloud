module Spree
  class AnnexCloudReward < Spree::Base
    belongs_to :variant
    scope :active, -> { where(active: true) }

    delegate :product, to: :variant

    # Import rewards from AnnexCloud
    def self.import
      url = "#{SpreeAnnexCloud::ANNEX_CLOUD_API_BASE_URL}/rewardlist/#{SpreeAnnexCloud.configuration.site_id}"
      response = HTTParty.get url, query: { access_token: SpreeAnnexCloud.configuration.access_token }
      return if response.blank? ||
          response['error_code'] != '0' ||
          response['reward_details'].blank?

      # Import rewards
      response['reward_details'].each do |resource|
        import_from_resource(resource)
      end

      # Deactivate rewards not included in import
      imported_reward_ids = response['reward_details'].map { |reward| reward['reward_id'] }
      where.not(annex_cloud_id: imported_reward_ids).update_all(active: false)
    end

    # Import reward from AnnexCloud resource
    #
    # Resource Example
    # {
    #   reward_id: "102517",
    #   reward_name: "Mini Candle",
    #   earned_points_required: "500",
    #   product_sku_id: "41602",
    #   reward_status: "1",
    #   reward_description: "",
    #   reward_url: "//cdn.socialannex.com/custom_images/8989250/Z6BTOR_mdc.png"
    # },
    #
    def self.import_from_resource(resource)
      reward = find_or_create_by!(annex_cloud_id: resource['reward_id'])
      variant = Spree::Variant.find_by_sku(resource['product_sku_id'])
      reward.update(
        active: variant.present? && resource['reward_status'] == '1',
        description: resource['reward_description'],
        image: resource['reward_url'],
        points_required: resource['earned_points_required'],
        name: resource['reward_name'],
        variant: variant
      )
    end
  end
end

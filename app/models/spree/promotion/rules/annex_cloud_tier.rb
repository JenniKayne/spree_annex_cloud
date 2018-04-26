module Spree
  class Promotion
    module Rules
      class AnnexCloudTier < PromotionRule
        include Spree::Promotion::Rules::AnnexCloudRegistered::AnnexCloudValidation

        preference :tier, :string, default: 'beige'

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})
          validate_annex_cloud_user(order)
          if eligibility_errors.empty?
            validate_annex_cloud_tier(order, preferred_tier)
          end
          eligibility_errors.empty?
        end
      end
    end
  end
end

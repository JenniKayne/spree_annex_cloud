module Spree
  class Promotion
    module Rules
      class AnnexCloudRegistered < PromotionRule
        include Spree::Promotion::Rules::AnnexCloudRegistered::AnnexCloudValidation

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, _options = {})
          validate_annex_cloud_user(order)
          eligibility_errors.empty?
        end
      end
    end
  end
end

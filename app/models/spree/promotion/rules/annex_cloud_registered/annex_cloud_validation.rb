module Spree
  class Promotion
    module Rules
      class AnnexCloudRegistered < PromotionRule
        module AnnexCloudValidation
          def validate_annex_cloud_user(order)
            if order.user.blank?
              eligibility_errors.add(:base, eligibility_error_message(:no_user_specified))
            elsif !order.user.annex_cloud_registered?
              eligibility_errors.add(:base, eligibility_error_message(:user_not_registered_in_annex_cloud))
            end
          end

          def validate_annex_cloud_tier(order, tier)
            if order.user.annex_cloud_user.tier.to_s.casecmp(tier) != 0
              eligibility_errors.add(:base, eligibility_error_message(:no_annex_cloud_tier_match))
            end
          end
        end
      end
    end
  end
end

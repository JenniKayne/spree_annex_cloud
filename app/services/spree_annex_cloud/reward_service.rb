module SpreeAnnexCloud
  class RewardService
    attr_accessor :order, :reward, :param_options

    def initialize(args = {})
      @order = args[:order]
      @reward = args[:reward]
      @param_options = args[:param_options]
    end

    def call
      create_perform if create_allowed? && !reward.product.is_gift_card?

      if @error
        return json_error(@error)
      else
        order.update_with_updater!
        return json_success
      end
    end

    private

    def enough_points?
      points_required = order.annex_cloud_points_required + reward.points_required
      unless points_required <= order.user.annex_cloud_available_points
        @error = Spree.t('annex_cloud.not_enough_points')
        return false
      end
      true
    end

    def can_redeem_free_reward?
      if reward.points_required.zero? && item_already_redeemed?
        @error = Spree.t('annex_cloud.already_redeem_free_product')
        return false
      end
      true
    end

    def create_allowed?
      return false unless order.user.present? && reward.present?

      enough_points? && can_redeem_free_reward?
    end

    def item_already_redeemed?
      order.user.orders.joins(:line_items).
        where('spree_line_items.variant_id = ? AND spree_line_items.price = ?', reward.variant_id, 0.to_f).
        count.positive?
    end

    def create_perform
      @line_item = order.contents.add(reward.variant, 1, param_options)
    rescue ActiveRecord::RecordInvalid => error
      @error = error.record.errors.full_messages.join(', ')
    rescue StandardError => error
      @error = error.message
    end

    def json_error(error)
      { success: false, error: error }
    end

    def json_success
      { success: true }
    end
  end
end

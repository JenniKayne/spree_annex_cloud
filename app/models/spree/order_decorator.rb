Spree::Order.class_eval do
  register_line_item_comparison_hook :line_item_reject_match_for_annex_cloud_rewards

  def annex_cloud_points_required
    line_items.sum(&:annex_cloud_points_required)
  end

  def annex_cloud_reward?
    line_items.any?(&:annex_cloud_reward?)
  end

  def annex_cloud_reward_valid?
    user.nil? || annex_cloud_points_required <= user.annex_cloud_available_points
  end

  def ensure_annex_cloud_reward_valid
    if !annex_cloud_reward_valid?
      restart_checkout_flow
      errors.add(:base, Spree.t('annex_cloud.not_enough_points'))
      false
    else
      true
    end
  end

  def line_item_reject_match_for_annex_cloud_rewards(line_item, _options = {})
    !line_item.annex_cloud_reward?
  end
end

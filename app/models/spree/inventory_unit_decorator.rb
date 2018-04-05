Spree::InventoryUnit.class_eval do
  after_update :annex_cloud_after_return

  def annex_cloud_after_return
    return unless saved_change_to_state? && state == 'returned' && variant.annex_cloud_reward?
    user = order.user
    return unless user.annex_cloud_registered?

    user.annex_cloud_user.add_points(
      variant.annex_cloud_reward.points_required,
      reason: return_items.map(&:customer_return).compact.map { |r| "Return ##{r.number}" }.join(', ')
    )
  end
end

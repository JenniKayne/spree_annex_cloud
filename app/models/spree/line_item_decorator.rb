Spree::LineItem.class_eval do
  def annex_cloud_reward?
    variant.annex_cloud_reward?
  end

  def annex_cloud_points_required
    variant.annex_cloud_points_required * quantity
  end
end

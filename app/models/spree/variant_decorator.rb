Spree::Variant.class_eval do
  has_one :annex_cloud_reward

  def annex_cloud_reward?
    annex_cloud_reward.present?
  end

  def annex_cloud_points_required
    @annex_cloud_points_required ||= annex_cloud_reward.present? ? annex_cloud_reward.points_required : 0
  end
end

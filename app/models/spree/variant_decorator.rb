Spree::Variant.class_eval do
  has_one :annex_cloud_reward

  def annex_cloud_data
    {
      id: sku,
      price: price,
      product_name: name
    }.
      merge(annex_cloud_data_category).
      merge(annex_cloud_data_url)
  end

  def annex_cloud_data_category
    {}
  end

  def annex_cloud_data_url
    {}
  end

  def annex_cloud_points_required
    @annex_cloud_points_required ||= annex_cloud_reward? ? annex_cloud_reward.points_required : 0
  end

  def annex_cloud_reward?
    annex_cloud_reward.present?
  end
end

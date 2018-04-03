Spree::Order.class_eval do
  register_line_item_comparison_hook :line_item_reject_match_for_annex_cloud_rewards

  def annex_cloud_pixel_params
    {
      site_id: SpreeAnnexCloud.configuration.site_id,
      order_id: number,
      sale_amount: total,
      email_id: email,
      name: user.try(:full_name),
      fname: user.try(:firstname),
      lname: user.try(:lastname),
      order_discount: adjustments.promotion.sum(&:amount),
      coupon: promo_code,
      rewards_applied: annex_cloud_reward_json,
      exclude_products: annex_cloud_product_json
    }.map { |key, value| "#{key}=#{value}" }.join('&')
  end

  def annex_cloud_points_required
    line_items.sum(&:annex_cloud_points_required)
  end

  def annex_cloud_products
    line_items.
      reject(&:annex_cloud_reward?).
      map(&:annex_cloud_data).
      each_with_index.map do |line, index|
        [index, line]
      end.to_h
  end

  def annex_cloud_product_json
    annex_cloud_products.to_json
  end

  def annex_cloud_reward?
    line_items.any?(&:annex_cloud_reward?)
  end

  def annex_cloud_reward_json
    annex_cloud_rewards.to_json
  end

  def annex_cloud_reward_valid?
    user.nil? || annex_cloud_points_required <= user.annex_cloud_available_points
  end

  def annex_cloud_rewards
    rewards = {}
    line_items.
      select(&:annex_cloud_reward?).each do |line|
        variant = line.variant
        reward_id = variant.annex_cloud_reward.id
        rewards[reward_id] ||= { rid: reward_id, quantity: 0, sku: variant.sku }
        rewards[reward_id][:quantity] += line.quantity
      end
    rewards.values.each_with_index.map { |reward, index| [index, reward] }.to_h
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

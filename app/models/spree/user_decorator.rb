Spree::User.class_eval do
  has_one :annex_cloud_user

  delegate :email, to: :annex_cloud_user, prefix: :annex_cloud

  after_create :synchronize_annex_cloud_agree_attribute
  after_update :synchronize_annex_cloud_agree_attribute
  after_update :synchronize_annex_cloud_resource

  def annex_cloud_register_try
    return true if annex_cloud_registered?

    resource = Spree::AnnexCloudUser.annex_cloud_resource_by_email(email)
    return false if resource.blank?

    opt_in_resource = Spree::AnnexCloudUser.annex_cloud_opt_in_by_email(email)
    return false if opt_in_resource.blank? || opt_in_resource[:explicit_status].blank? || opt_in_resource[:explicit_status].to_i.zero?

    if annex_cloud_user.present? && !annex_cloud_user.registered?
      annex_cloud_user.update(
        annex_cloud_id: resource['user_id'],
        email: email
      )
    else
      update_column(:annex_cloud_agree, true) unless annex_cloud_agree
      if annex_cloud_user.blank?
        update(annex_cloud_user: Spree::AnnexCloudUser.create!(annex_cloud_id: resource['user_id'], email: email))
      end
    end
    SpreeAnnexCloud::UpdateAnnexCloudResource.perform_later annex_cloud_user
  end

  def annex_cloud_registered?
    annex_cloud_user.present? && annex_cloud_user.registered?
  end

  def annex_cloud_available_points
    annex_cloud_registered? ? annex_cloud_user.available_points : 0
  end

  def synchronize_annex_cloud_agree_attribute
    return unless saved_change_to_annex_cloud_agree? && annex_cloud_agree

    unless annex_cloud_user.present?
      update annex_cloud_user: Spree::AnnexCloudUser.create!(email: email)
    end
    annex_cloud_user.register
  end

  def synchronize_annex_cloud_resource
    return unless annex_cloud_registered? && (saved_change_to_firstname? || saved_change_to_lastname? || saved_change_to_birthday?)
    SpreeAnnexCloud::UpdateAnnexCloudResource.perform_later annex_cloud_user
  end
end

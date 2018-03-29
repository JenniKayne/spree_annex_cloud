Spree::User.class_eval do
  has_one :annex_cloud_user

  delegate :email, to: :annex_cloud_user, prefix: :annex_cloud

  after_create :synchronize_annex_cloud_agree_attribute
  after_update :synchronize_annex_cloud_agree_attribute

  def annex_cloud_registered?
    annex_cloud_user.present?
  end

  def annex_cloud_available_points
    annex_cloud_registered? ? annex_cloud_user.available_points : 0
  end

  def synchronize_annex_cloud_agree_attribute
    return unless saved_change_to_annex_cloud_agree? &&
        annex_cloud_agree &&
        annex_cloud_user.nil?

    update annex_cloud_user: Spree::AnnexCloudUser.create!(email: email)
    annex_cloud_user.register
  end
end

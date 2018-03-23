Spree::User.class_eval do
  has_one :annex_cloud_user

  deletege :annex_cloud_id, to: :annex_cloud_user
  deletege :email, to: :annex_cloud_user, prefix: :annex_cloud

  after_create :synchronize_annex_cloud_agree_attribute
  after_update :synchronize_annex_cloud_agree_attribute

  def synchronize_annex_cloud_agree
    return unless annex_cloud_agree.changed?

    if annex_cloud_agree && annex_cloud_user.nil?
      update annex_cloud_user: Spree::AnnexCloudUser.create!(email: email)
      annex_cloud_user.register
    # elsif !annex_cloud_agree && annex_cloud_user.present?
    #   annex_cloud_user.destroy
    end
  end
end

class AddAnnexCloudAgreeToSpreeUsers < ActiveRecord::Migration[5.1]
  add_column :spree_users, :annex_cloud_agree, :boolean, default: false
end

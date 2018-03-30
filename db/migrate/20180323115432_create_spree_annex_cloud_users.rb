class CreateSpreeAnnexCloudUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_annex_cloud_users do |t|
      t.integer :user_id
      t.integer :annex_cloud_id
      t.string :email
      t.boolean :reported_to_annex_cloud, default: false
      t.timestamps null: true
    end
  end
end

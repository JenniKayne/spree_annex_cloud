class CreateSpreeAnnexCloudRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_annex_cloud_rewards do |t|
      t.boolean :active, default: false
      t.integer :annex_cloud_id
      t.integer :points_required
      t.integer :variant_id
      t.string :image
      t.string :name
      t.text :description
      t.timestamps null: true
    end
  end
end

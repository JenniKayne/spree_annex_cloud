class CreateSubscriptions < ActiveRecord::Migration[5.1]
  create_table :spree_annex_cloud_user do |t|
    t.integer :user_id
    t.integer :annex_cloud_id
    t.string :email
    t.timestamps null: true
  end
end

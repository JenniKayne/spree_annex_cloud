Spree::Core::Engine.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    post 'redeem_reward' => 'annex_cloud#create', as: :redeem_reward
  end
end

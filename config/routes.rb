Spree::Core::Engine.routes.draw do
  get '/refer-a-friend' => 'annex_cloud#refer_a_friend'
  get '/rewards-dashboard' => 'annex_cloud#rewards_dashboard'

  namespace :api, defaults: { format: 'json' } do
    post 'redeem_reward' => 'annex_cloud#create', as: :redeem_reward
  end
end

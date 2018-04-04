module Spree
  class AnnexCloudController < Spree::StoreController
    before_action :authorize_current_spree_user, only: [:refer_a_friend, :rewards_dashboard]

    def refer_a_friend; end

    def rewards_dashboard; end

    protected

    def authorize_current_spree_user
      redirect_to '/login?refer=true' if current_spree_user.nil?
      current_spree_user.annex_cloud_register_try
    end
  end
end

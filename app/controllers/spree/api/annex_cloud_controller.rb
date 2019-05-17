module Spree
  module Api
    class AnnexCloudController < Spree::BaseController
      include Spree::Core::ControllerHelpers::Auth
      include Spree::Core::ControllerHelpers::Order
      before_action :load_order, :load_reward, only: :create

      private

      def load_order
        @order = current_order(create_order_if_necessary: true)
      end

      def load_reward
        return if params[:reward_id].nil?

        @reward = Spree::AnnexCloudReward.active.find_by(annex_cloud_id: params[:reward_id])
      end

      def param_options
        params[:options] || {}
      end
    end
  end
end

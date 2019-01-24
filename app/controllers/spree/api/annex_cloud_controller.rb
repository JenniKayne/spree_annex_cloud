module Spree
  module Api
    class AnnexCloudController < Spree::BaseController
      include Spree::Core::ControllerHelpers::Auth
      include Spree::Core::ControllerHelpers::Order
      before_action :load_order, only: :create
      before_action :load_reward, only: :create

      def create
        result = SpreeAnnexCloud::RewardService.new(order: @order, reward: @reward, param_options: param_options).call
        respond_to do |format|
          format.html do
            if result[:success]
              flash[:success] = Spree.t('annex_cloud.reward_added_to_cart', name: @reward.product.name)
            else
              flash[:error] = result[:error]
            end
            redirect_to :rewards_dashboard
          end
          format.json { render json: result }
        end
      end

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

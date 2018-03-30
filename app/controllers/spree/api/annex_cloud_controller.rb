module Spree
  module Api
    class AnnexCloudController < Spree::BaseController
      include Spree::Core::ControllerHelpers::Auth
      include Spree::Core::ControllerHelpers::Order
      before_action :load_order, only: :create
      before_action :load_reward, only: :create

      def create
        if create_allowed
          create_perform

          if @error
            render json: json_error(@error)
          else
            @order.update_with_updater!
            render json: json_success
          end
        else
          render json: json_error(Spree.t('annex_cloud.not_enough_points'))
        end
      end

      private

      def create_allowed
        return false unless @order.user.present? && @reward.present?
        points_required = @order.annex_cloud_points_required + @reward.points_required
        points_required <= @order.user.annex_cloud_available_points
      end

      def create_perform
        @order.contents.add(@reward.variant, 1, param_options)
      rescue ActiveRecord::RecordInvalid => error
        @error = error.record.errors.full_messages.join(', ')
      rescue StandardError => error
        @error = error.message
      end

      def json_error(error)
        { success: false, error: error }
      end

      def json_success
        { success: true }
      end

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

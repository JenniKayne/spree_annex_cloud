Spree::ProductsController.class_eval do
  before_action :prevent_reward_show, only: :show

  private

  def prevent_reward_show
    product = @product || Spree::Product.find(params[:id])
    redirect_to root_path if Spree::AnnexCloudReward.where(variant: product.variants_including_master).any?
  end
end

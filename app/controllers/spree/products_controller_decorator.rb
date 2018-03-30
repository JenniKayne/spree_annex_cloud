Spree::ProductsController.class_eval do
  before_action :prevent_reward_show, only: :show

  private

  def prevent_reward_show
    redirect_to root_path
  end
end

require 'spec_helper'

describe SpreeAnnexCloud::RewardService, type: :service do

  let(:variant) { create(:variant, price: 0) }
  let(:user) { create(:user) }
  let(:order) { create(:order, user: user) }
  let(:old_order) { create(:order, user: user) }
  let(:free_reward) do
    Spree::AnnexCloudReward.create!(
      active: true,
      annex_cloud_id: 123,
      points_required: 0,
      variant: variant,
      name: 'Free Reward'
    )
  end

  let(:reward_5000) do
    Spree::AnnexCloudReward.create!(
      active: true,
      annex_cloud_id: 123,
      points_required: 5000,
      variant: variant,
      name: 'Free Reward'
    )
  end

  let(:reward) do
    Spree::AnnexCloudReward.create!(
      active: true,
      annex_cloud_id: 123,
      points_required: 500,
      variant: variant,
      name: 'Free Reward'
    )
  end

  before do
    allow_any_instance_of(Spree::User).to receive(:firstname) { 'test' }
    allow_any_instance_of(Spree::User).to receive(:lastname) { 'user' }
    allow_any_instance_of(Spree::User).to receive(:birthday) { Date.today - 20.years }
  end

  describe '.call' do
    context 'free reward' do
      before { allow_any_instance_of(Spree::User).to receive(:annex_cloud_available_points) { 100 } }

      context 'first time' do
        it 'can add reward' do
          expect(described_class.new(order: order, reward: free_reward).call).to eq({ success: true })
        end
      end

      context 'not first time' do
        it 'cannot add reward' do
          described_class.new(order: old_order, reward: free_reward).call
          expect(described_class.new(order: order, reward: free_reward).call).to eq({ success: false, error: 'Cannot redeem this reward twice' })
        end
      end
    end

    context 'reward' do
      before { allow_any_instance_of(Spree::User).to receive(:annex_cloud_available_points) { 1000 } }

      context '500 reward' do
        it 'can add reward' do
          expect(described_class.new(order: order, reward: reward).call).to eq({ success: true })
        end

        it 'can add reward twice' do
          described_class.new(order: order, reward: reward).call
          expect(described_class.new(order: order, reward: reward).call).to eq({ success: true })
        end
      end

      context '5000 reward' do
        it 'cannot add reward' do
          expect(described_class.new(order: order, reward: reward_5000).call).to eq({ success: false, error: 'Not enough points to redeem the reward' })
        end
      end
    end

  end

end

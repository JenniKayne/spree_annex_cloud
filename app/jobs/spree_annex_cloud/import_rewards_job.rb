module SpreeAnnexCloud
  class ImportRewardsJob < ActiveJob::Base
    queue_as :annex_cloud

    def perform
      Spree::AnnexCloudReward.import if SpreeAnnexCloud.configuration.enabled
    rescue StandardError => error
      Raven.capture_exception(error)
    end
  end
end

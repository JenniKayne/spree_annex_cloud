module SpreeAnnexCloud
  class ImportRewardsJob < ActiveJob::Base
    queue_as :annex_cloud

    def perform
      Spree::AnnexCloudReward.import if SpreeAnnexCloud.configuration.enabled
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error)
      raise error
    end
  end
end

module SpreeAnnexCloud
  class UpdateAnnexCloudResource < ActiveJob::Base
    queue_as :annex_cloud

    def perform(annex_cloud_user)
      annex_cloud_user.update_resource
    rescue StandardError => error
      Raven.capture_exception(error)
    end
  end
end

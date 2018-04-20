module SpreeAnnexCloud
  class UpdateAnnexCloudResource < ActiveJob::Base
    queue_as :annex_cloud

    def perform(annex_cloud_user)
      annex_cloud_user.update_resource
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error)
      raise error
    end
  end
end

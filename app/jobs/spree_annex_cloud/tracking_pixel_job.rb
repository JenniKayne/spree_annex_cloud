module SpreeAnnexCloud
  class TrackingPixelJob < ActiveJob::Base
    queue_as :annex_cloud

    def perform(order)
      url = 'https://c.socialannex.com/c-sale-track'
      response = HTTParty.get url, query: order.annex_cloud_pixel_params

      raise "Failed Tracking Pixel #{order.number}" unless response.present? && response.success?
    rescue StandardError => error
      Raven.capture_exception(error)
    end
  end
end

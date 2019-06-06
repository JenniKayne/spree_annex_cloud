module SpreeAnnexCloud
  class TrackingPixelWithoutOrderJob < ActiveJob::Base
    queue_as :annex_cloud

    def perform(gift_card)
      url = 'https://c.socialannex.com/c-sale-track'
      response = HTTParty.get url, query: gift_card[:annex_cloud_pixel_params]

      raise "Failed Tracking Pixel #{gift_card[:number]}" unless response.present? && response.success?
    rescue StandardError => error
      Raven.capture_exception(error)
    end
  end
end

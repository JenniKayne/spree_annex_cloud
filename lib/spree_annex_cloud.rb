require 'spree_core'
require 'spree_extension'
require 'spree_annex_cloud/engine'
require 'spree_annex_cloud/version'

module SpreeAnnexCloud
  class Configuration
    attr_accessor :access_token
    attr_accessor :site_id

    def initialize
      @access_token = ''
      @site_id = ''
    end
  end

  class << self
    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end

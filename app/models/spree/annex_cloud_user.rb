module Spree
  class AnnexCloudUser
    include Spree::AnnexCloudUser::Api
    belongs_to :user

    def register
      params = {
        first_name: user.firstname,
        last_name: user.lastname,
        birth_date: (user.birthdate.strftime('%Y-%m-%d') unless user.birthdate.nil?)
      }
      annex_cloud_post(api_user_url, params)
    end
  end
end

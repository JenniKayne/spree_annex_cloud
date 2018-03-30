Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins Rails.application.secrets.annex_cloud_cors_origins.split(',')
    resource '/api/redeem_reward*', headers: :any, methods: :any
  end
end

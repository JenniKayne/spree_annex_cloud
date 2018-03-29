namespace :spree_annex_cloud do
  desc 'Import rewards'
  task import_rewards: :environment do
    SpreeAnnexCloud::ImportRewardsJob.perform_now
  end

  desc 'Schedule: Import rewards'
  task schedule_import_rewards: :environment do
    SpreeAnnexCloud::ImportRewardsJob.perform_later
  end
end

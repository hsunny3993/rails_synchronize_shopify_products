# frozen_string_literal: true

require "sidekiq"
require "sidekiq-unique-jobs"
schedule_file = "config/schedule.yml"

Sidekiq.configure_client do |config|
  config.redis = {url: ENV['REDIS_URL'], reconnect_attempts: 1}

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end
end

Sidekiq.configure_server do |config|
  config.redis = {url: ENV['REDIS_URL'], reconnect_attempts: 1}

  config.client_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Client
  end

  config.server_middleware do |chain|
    chain.add SidekiqUniqueJobs::Middleware::Server
  end

  SidekiqUniqueJobs::Server.configure(config)
end

if File.exist?(schedule_file)
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
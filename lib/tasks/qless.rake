require 'qless/tasks'

namespace :qless do

  task :setup => :environment do
    # Set options via environment variables
    # The only required option is QUEUES; the
    # rest have reasonable defaults.
    ENV['QUEUES'] ||= 'matching'
    ENV['INTERVAL'] ||= '10' # 10 seconds
    ENV['VVERBOSE'] ||= 'true'
  end
end
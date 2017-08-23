require 'rspec/core/rake_task'

namespace 'db' do
  desc 'Run database migrations'
  task :migrate do |t, args|
    cmd = "sequel -m database/migrations sqlite://database/db.sqlite3"
    puts cmd
    puts `#{cmd}`
  end
end

RSpec::Core::RakeTask.new :spec do |task|
  task.pattern = "./spec/**/*_spec.rb"
end

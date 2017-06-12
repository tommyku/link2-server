namespace 'db' do
  desc 'Run database migrations'
  task :migrate do |t, args|
    cmd = "sequel -m database/migrations sqlite://database/db.sqlite3"
    puts cmd
    puts `#{cmd}`
  end
end

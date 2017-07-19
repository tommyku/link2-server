require 'logger'

DB = Sequel.connect(
  'sqlite://database/db.sqlite3',
  loggers: [Logger.new($stdout)]
)

DB.sql_log_level = :debug

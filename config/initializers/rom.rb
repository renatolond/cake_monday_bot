require "rom"
require "rom-sql"

ROM.container(:sql, ENV.fetch("DATABASE_URL"))

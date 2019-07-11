require "rom"
require "rom-sql"

$rom ||= ROM.container(:sql, ENV.fetch("DATABASE_URL"))

# frozen_string_literal: true

require "rom"
require "rom-sql"

module Persistence
  def self.config
    @config ||= ROM::Configuration.new(:sql, ENV.fetch("DATABASE_URL"))
  end

  def self.db
    @db ||= config.gateways[:default]
  end

  def self.rom
    raise "not finalized" unless instance_variable_defined?(:@rom)
    @rom
  end

  def self.finalize
    @rom ||= begin
               config.auto_registration __dir__
               ROM.container(config)
             end
  end
end

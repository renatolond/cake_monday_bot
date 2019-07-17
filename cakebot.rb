require "dotenv/load"
require "slack-ruby-bot"
require "thor"

require_relative "config/initializers/rom"

require_relative "app/services/draw_candidate_service"

require_relative "app/objects/cake_bot"

class CakeBotCommands < Thor
  desc "draw", "Draw a user to bring cake and send a message to the configured channel"
  def draw
    candidate = DrawCandidateService.new.draw
    puts candidate.name
  end

  desc "add NAME", "Adds a user to the database"
  def add(*name)
    raise "Not implemented"
  end

  desc "start", "Starts the bot, do not daemonize"
  def start
    CakeBot.run
  end
end

CakeBotCommands.start(ARGV)

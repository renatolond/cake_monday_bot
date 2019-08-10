# frozen_string_literal: true

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

    web_client.chat_postMessage(text: "Hey, <@#{candidate.slack_at}>, you bring the cake next week!", channel: slack_channel, link_names: true)
  end

  desc "remind", "Send a reminder to the last drawn user to the configured channel"
  def remind
    candidate = candidates_repo.last_drawn

    web_client.chat_postMessage(text: "Hey, <@#{candidate.slack_at}>, just to remind you. Monday you need to bring the cake!", channel: slack_channel, link_names: true)
  end

  desc "add SLACK_AT NAME", "Adds a user to the database, pass the user @, like renatolond, and their name"
  def add(slack_at, *name)
    name = name.join(" ")
    candidates_repo.create(slack_at: slack_at, name: name)
    puts "User #{name} added as @#{slack_at}"
  rescue ROM::SQL::UniqueConstraintError
    puts "User with @#{slack_at} already existed. Ignoring!"
  end

  desc "start", "Starts the bot, do not daemonize"
  def start
    CakeBot.run
  end

  private

    def slack_channel
      @slack_channel ||= ENV.fetch("SLACK_CHANNEL", "random")
    end

    def candidates_repo
      @candidates_repo ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end

    def web_client
      web_client ||= Slack::Web::Client.new(token: ENV["SLACK_API_TOKEN"])
    end
end

CakeBotCommands.start(ARGV)

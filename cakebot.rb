# frozen_string_literal: true

require "dotenv/load"
require "slack-ruby-bot"
require "thor"

require_relative "config/initializers/rom"

require_relative "app/services/draw_candidate_service"

require_relative "app/objects/cake_bot"

class CakeBotCommands < Thor
  desc "draw", "Draw a user to bring cake and send a message to the configured channel"
  def draw(tag_limit = 2)
    tag_limit = tag_limit.to_i
    tags = ""
    candidate_list = DrawCandidateService.new.draw(tag_limit)
    tags = build_tags_from_candidates(candidate_list)

    web_client.chat_postMessage(text: "Hey, #{tags}, you bring a cake next week!", channel: slack_channel, link_names: true, as_user: true)
  end

  desc "remind", "Send a reminder to the last drawn user to the configured channel"
  def remind
    candidates = candidates_repo.last_drawn
    tags = build_tags_from_candidates(candidates)
    web_client.chat_postMessage(text: "Hey, #{tags}, just to remind you. Tuesday you need to bring a cake!", channel: slack_channel, link_names: true, as_user: true)
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

    def build_tags_from_candidates(candidate_list)
      tags = ""
      candidate_list.each_with_index do |candidate, index|
        case index
        when 0
          tags += "<@#{candidate.slack_at}>"
        when candidate_list.size - 1
          tags += " and <@#{candidate.slack_at}>"
        else
          tags += " ,<@#{candidate.slack_at}>"
        end
      end
      tags
    end

    def candidates_repo
      @candidates_repo ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end

    def web_client
      web_client ||= Slack::Web::Client.new(token: ENV["SLACK_API_TOKEN"])
    end
end

CakeBotCommands.start(ARGV)

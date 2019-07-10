require "dotenv/load"
require "slack-ruby-bot"
require_relative "config/initializers/rom"

class PongBot < SlackRubyBot::Bot
  command 'ping' do |client, data, match|
    client.say(text: 'pong', channel: data.channel)
  end
end

PongBot.run

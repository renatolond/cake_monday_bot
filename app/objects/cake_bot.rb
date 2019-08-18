# frozen_string_literal: true

class CakeBot < SlackRubyBot::Bot
  command "ping" do |client, data, match|
    client.say(text: "pong", channel: data.channel)
  end

  match /^Add <@(?<slack_at>[\w]+)>(?: (?<name>[\w ]+))?/i do |client, data, match|
    name = match[:name] || ""
    slack_at = match[:slack_at]
    candidates_repository.create(slack_at: slack_at, name: name)
    client.say(channel: data.channel, text: "Alrite! I've added <@#{slack_at}> to the game!")
  rescue ROM::SQL::UniqueConstraintError
    client.say(channel: data.channel, text: "Looks like <@#{slack_at}> was already added. I didn't do anything.")
  end

  match /^Make unavailable <(?<user>@[\w]+)>/i do |client, data, match|
    client.say(channel: data.channel, text: "Okay, let's make it so")
    user = candidates_repository.find_by_slack_at(match[:user])
    if user.nil?
      client.say(channel: data.channel, text: "Hm, I don't know <#{match[:user]}>, maybe add them first?")
    else
      candidates_repository.make_unavailable(user.id)
      client.say(channel: data.channel, text: "Done! <#{match[:user]}> is unavailable now.")
    end
  end

  match /^Make available <(?<user>@[\w]+)>/i do |client, data, match|
    client.say(channel: data.channel, text: "Okay, let's make it so")
    puts match[:user]
    client.say(channel: data.channel, text: "Done! <#{match[:user]}> is available again.")
  end

  private

    def self.candidates_repository
      @@candidates_repository ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end
end

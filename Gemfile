# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Lib used to communicate with slack and facilitate bot writing
gem "slack-ruby-bot", "~> 0.12.0"
# Limit the version of async-websocket for slack-ruby-bot
gem "async-websocket", "~> 0.8.0"
# Used to load .env files automagically
gem "dotenv"
# The ORM we use
gem "rom"
# The gem for the sql bindings for rom
gem "rom-sql"
# We use postgres, so we need pg for rom
gem "pg"
# We use rake for tasks such as migrating the db
gem "rake"
# Thor is used to write commands for the bot
gem "thor"

group :development do
  # Used to debug with binding.pry
  gem "pry-byebug"
  # Rubocop is a ruby linter, for code formatting
  gem "rubocop"
  # Extra gem for performance rules for rubocop
  gem "rubocop-performance"
  # Pronto makes it easier to run linting against changed files only
  gem "pronto"
  # Extra gem to add support for rubocop to pronto
  gem "pronto-rubocop"
  # lefthook manages git hooks for the project
  gem "lefthook"
end

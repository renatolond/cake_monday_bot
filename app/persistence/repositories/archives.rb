# frozen_string_literal: true

require_relative "base"

module Persistence
  module Repositories
    class Archives < ROM::Repository[:archives]
      commands :create, update: :by_pk, delete: :by_pk

      def last_selected
        archives.where(drawn_at: (Date.today - 7)..Time.now).order { drawn_at.desc }.to_a
      end
    end
  end
end

# frozen_string_literal: true

require_relative "base"

module Persistence
  module Repositories
    class Archives < ROM::Repository[:archives]
      commands :create, update: :by_pk, delete: :by_pk

      def last_selected
        archives.order { drawn_at.desc }.first
      end
    end
  end
end

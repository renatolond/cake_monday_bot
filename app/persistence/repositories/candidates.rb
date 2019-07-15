require_relative "base"

module Persistence
  module Repositories
    class Candidates < ROM::Repository[:candidates]
      commands :create, update: :by_pk, delete: :by_pk

      def available
        candidates.where(available: true)
      end
    end
  end
end

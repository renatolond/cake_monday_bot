require_relative "base"

module Persistence
  module Repositories
    class Candidates < ROM::Repository[:candidates]
      commands :create, update: :by_pk, delete: :by_pk

      def available
        candidates.where(available: true)
      end

      def reset_pool
        candidates.command(:update).call(available: true)
      end

      def make_unavailable(user_id)
        candidates.by_pk(user_id).command(:update).call(available: false)
      end
    end
  end
end

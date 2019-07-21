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

      def make_unavailable(candidate_id)
        candidates.by_pk(candidate_id).command(:update).call(available: false)
      end

      def find(candidate_id)
        candidates.by_pk(candidate_id).one
      end

      def last_drawn
        id = Archives.new(Persistence.rom).last_selected.candidate_id
        candidates.by_pk(id).one
      end
    end
  end
end

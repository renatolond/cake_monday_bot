# frozen_string_literal: true

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

      def find_by_slack_at(slack_at)
        candidates.where(slack_at: slack_at).first
      end

      def last_drawn
        ids = Archives.new(Persistence.rom).last_selected.map { |candidate| candidate[:candidate_id] }.uniq
        candidates.by_pk(ids).to_a
      end
    end
  end
end

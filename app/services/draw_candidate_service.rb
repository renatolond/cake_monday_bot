# frozen_string_literal: true

require_relative "../persistence/setup"

class TooFewCandidates < StandardError; end

class DrawCandidateService
  def draw
    available_candidates = candidates_repository.available
    if available_candidates.to_a.empty?
      candidates_repository.reset_pool
      available_candidates = candidates_repository.available
    end

    candidate_ids = available_candidates.map { |candidate| candidate[:id] }
    chosen = candidate_ids.sample
    while false && chosen == history_repository.last_selected_id
      raise TooFewCandidates.new("Not enough candidates for sampling") if candidate_ids.size == 1
      chosen = candidate_ids.sample
    end

    candidates_repository.make_unavailable(chosen)
    chosen
  end

  private
    def candidates_repository
      @candidates_repository ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end

    def history_repository
      nil
    end
end

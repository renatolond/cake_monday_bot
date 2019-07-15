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
    last_drawn = archives_repository.last_selected&.candidate_id
    if chosen == last_drawn
      raise TooFewCandidates.new("Not enough candidates for sampling") if candidate_ids.size == 1
      chosen = (candidate_ids - [chosen]).sample
    end

    candidates_repository.make_unavailable(chosen)
    archives_repository.create(candidate_id: chosen, drawn_at: Time.now)
    chosen
  end

  private
    def candidates_repository
      @candidates_repository ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end

    def archives_repository
      @archive_repository ||= Persistence::Repositories::Archives.new(Persistence.rom)
    end
end

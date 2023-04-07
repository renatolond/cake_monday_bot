# frozen_string_literal: true

require_relative "../persistence/setup"

class TooFewCandidates < StandardError; end

class DrawCandidateService
  def draw(number = 2)
    candidates = []
    while candidates.size < number
      available_candidates = candidates_repository.available
      if available_candidates.to_a.empty?
        candidates_repository.reset_pool
        available_candidates = candidates_repository.available
      end

      candidate_ids = available_candidates.map { |candidate| candidate[:id] }
      chosen = candidate_ids.sample

      last_drawned_peoples = archives_repository.last_selected.map { |candidate| candidate[:candidate_id] }.uniq
      if last_drawned_peoples.include? chosen
        raise TooFewCandidates.new("Not enough candidates for sampling") if candidate_ids.size == last_drawned_peoples.size
        chosen = (candidate_ids - last_drawned_peoples).sample
      end

      candidates_repository.transaction do |t|
        candidates_repository.make_unavailable(chosen)
        archives_repository.create(candidate_id: chosen, drawn_at: Time.now)
      end

      picked_candidate = candidates_repository.find(chosen)
      candidates << picked_candidate unless candidates.include? picked_candidate
    end
    candidates
  end

  private
    def candidates_repository
      @candidates_repository ||= Persistence::Repositories::Candidates.new(Persistence.rom)
    end

    def archives_repository
      @archive_repository ||= Persistence::Repositories::Archives.new(Persistence.rom)
    end
end

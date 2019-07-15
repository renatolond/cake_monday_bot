# frozen_string_literal: true

require_relative "../persistence/setup"

class DrawCandidateService
  def draw
  end

  private
    def candidates_repository
      repo = Persistence::Repositories::Candidates.new(Persistence.rom)
    end
end

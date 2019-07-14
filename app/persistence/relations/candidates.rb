# frozen_string_literal: true

module Persistence
  module Relations
    class Candidates < ROM::Relation[:sql]
      schema(:candidates, infer: true)
    end
  end
end

# frozen_string_literal: true

module Persistence
  module Relations
    class Archives < ROM::Relation[:sql]
      schema(:archives, infer: true)
    end
  end
end

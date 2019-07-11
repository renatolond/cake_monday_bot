require_relative "base_repository"

class CandidatesRepository < ROM::Repository[:candidates]
  commands :create, update: :by_pk, delete: :by_pk
end

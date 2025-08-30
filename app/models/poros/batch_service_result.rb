module Poros
  class BatchServiceResult
    attr_reader :errors, :executed, :skipped

    def initialize(success, errors, executed, skipped)
      @success = success
      @errors = errors
      @executed = executed
      @skipped = skipped
    end

    def success?
      @success
    end
  end
end

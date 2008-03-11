module Synthesis
  extend Logging
  
  def report!
    if failed?
      ExpectationRecord.print_tested_expectations
      ExpectationRecord.print_untested_expectations
      ExpectationRecord.print_ignored
      log; log "FAILED."
      return -1
    end
    log; log "Verified #{ExpectationRecord.expectations.size} expectations"
    log "SUCCESS."
    0
  end
  
  def failed?
    ExpectationRecord.untested_expectations.any?
  end
  
  module_function :report!, :failed?
end
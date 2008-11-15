require "set"

$: << File.dirname(__FILE__)

require "synthesis/logging"
require "synthesis/recordable"
require "synthesis/object"
require "synthesis/class"
require "synthesis/module"
require "synthesis/expectation_record"
require "synthesis/method_invocation_watcher"
require "synthesis/expectation"
require "synthesis/expectation_matcher"
require "synthesis/expectation_interceptor"
require "synthesis/expectation_recorder"
require "synthesis/reporter"
require "synthesis/formatter"
require "synthesis/adapter"

require "callstack"
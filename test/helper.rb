require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'fluent/test'
require 'fluent/plugin/out_flowcounter_simple'
require 'fluent/plugin/filter_flowcounter_simple'

# Test stub for log.info
class Fluent::Log
  alias_method :info_raw, :info

  def info(message)
    self.write(message)
    self.flush
  end
end

class Test::Unit::TestCase
  def capture_log(log, &block)
    tmp = log.out
    log.out = StringIO.new
    yield
    return log.out.string
  ensure
    log.out = tmp
  end
end

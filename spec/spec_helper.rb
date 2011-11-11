$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'digest/md5'
require 'fileutils'
require 'rspec'
require '/Users/dnolan/Development/ninjs/lib/ninjs.rb'
require 'ninjs-framework'

def suppress_output(&block)
  original_stdout = $stdout
  $stdout = fake = StringIO.new
  
  begin
    yield
  ensure
    $stdout = original_stdout
  end
  
  fake.string
end

RSpec::Matchers.define(:be_same_file_as) do |epxected_file_path|
  match do |actual_file_path|
    md5_hash(actual_file_path).should == md5_hash(epxected_file_path)
  end
  
  def md5_hash(file_path)
    Digest::MD5.hexdigest(File.read(file_path))    
  end
end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

SPEC_DIR = File.expand_path(File.dirname(__FILE__))
TMP_DIR = "#{SPEC_DIR}/tmp"
FIXTURES = "#{SPEC_DIR}/fixtures"
LIB = File.expand_path('../lib', SPEC_DIR)
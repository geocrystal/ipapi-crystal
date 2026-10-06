require "spec"
require "../src/ipapi"

require "vcr"

VCR.configure do |settings|
  settings.cassette_library_dir = "#{__DIR__}/fixtures/vcr"
end

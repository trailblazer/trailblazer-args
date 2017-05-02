require "test_helper"

class ArgsTest < Minitest::Spec
  it do
    immutable = { repository: "User" }

    args = Trailblazer::Options.new(immutable)

    args[:model] = Module
    args[:model].must_equal Module

    immutable.inspect.must_equal %{{:repository=>\"User\"}}
  end
end

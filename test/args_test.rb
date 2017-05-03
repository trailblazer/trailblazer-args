require "test_helper"

class ArgsTest < Minitest::Spec

  it do
    immutable = { repository: "User" }

    args = Trailblazer::Options.new(immutable)

    #-
    # options[] and options[]=
    args[:model] = Module
    args[:model].must_equal Module

    immutable.inspect.must_equal %{{:repository=>\"User\"}}

    #-
    # options.to_mutable_data
    args.to_mutable_data.inspect.must_equal %{{:model=>Module}}

    #-
    # options.to_immutable_data
    args.to_containers.inspect.must_equal %{[{:repository=>\"User\"}]}

    #-

    args.to_options.inspect.must_equal %{<Skill {} {:repository=>\"User\"}>}

    options = args.to_options ->(mutable_data:, immutable_data:) do
      immutable_data.merge(
        modelFromOutside: mutable_data[:model]
      )
    end
    options.inspect.must_equal %{}
  end
end

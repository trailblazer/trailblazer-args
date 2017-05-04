require "test_helper"

class ArgsTest < Minitest::Spec
  Context = Trailblazer::Context

  it do
    immutable = { repository: "User" }

    ctx = Context::Build(immutable)

        # it {  }
        #-
        # options[] and options[]=
        ctx[:model] = Module
        ctx[:model].must_equal Module

    # it {  }
    immutable.inspect.must_equal %{{:repository=>\"User\"}}
    # it {  }
    ctx.decompose.must_equal [ {:repository=>"User"}, { :model=>Module } ]

    # strip mutable, build new one
    new_ctx = Context::Build(*ctx.decompose) do |original, mutable| # both structures should be read-only
      original.merge( a: mutable[:model] )
    end # this is our output, what do we want to tell the outer world?

        new_ctx[:current_user] = Class
        new_ctx[:current_user].must_equal Class

     # it {  }
    immutable.inspect.must_equal %{{:repository=>\"User\"}}
    ctx.decompose.must_equal [ {:repository=>"User"}, { :model=>Module } ]
    # it {  }
    new_ctx.decompose.must_equal [ { :repository=>"User", a: Module }, { current_user: Class } ]

    # #-
    # # options.to_mutable_data
    # args.to_mutable_data.inspect.must_equal %{{:model=>Module}}

    # #-
    # # options.to_immutable_data
    # args.to_containers.inspect.must_equal %{[{:repository=>\"User\"}]}

    # #-

    # args.to_options.inspect.must_equal %{<Skill {} {:repository=>\"User\"}>}

    # options = args.to_options ->(mutable_data:, immutable_data:) do
    #   immutable_data.merge(
    #     modelFromOutside: mutable_data[:model]
    #   )
    # end
    # options.inspect.must_equal %{}
  end

  it do
    immutable = { repository: "User", model: Module, current_user: Class }

    ctx = Context::Build(immutable) do |original, mutable|
      mutable
    end
  end
end


def MyStep( bla: A )
    my_step = ->(options, **) { bla }


  step = ->(direction, options, flow_options) do



    options # already implements the interface (needs/returns)

    options_with_injected = Context.new(options)
    options_with_injected[:injected] = bla


    # runner so we have tracing, etc.
      direction, options, flow_options = runner.(original_step, options_with_injected)



  end
end

step = ->(direction, options, flow_options) do
  needs   = []
  returns = []

  context_implementing_interface = Wrap(options, needs) # needs interface (could also happen in start)
    # also: mapping

    # IT SUPER IMPORTANT that we call the effective step via the runner, to collect input and output.
  # hier wird auf context_implementing_interface geschrieben
  direction, context_implementing_interface, flow_options = runner.(original_step, context_implementing_interface, flow_options)

  #
  [ direction,
    Unwrap(context_implementing_interface, returns), # returns interface (could also happen in stop)
    flow_options
  ]
end

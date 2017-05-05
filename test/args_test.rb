require "test_helper"

class ArgsTest < Minitest::Spec
  Context = Trailblazer::Context

  let (:immutable) { { repository: "User" } }

  it do
    ctx = Trailblazer::Context(immutable)

    # it {  }
    #-
    # options[] and options[]=
    ctx[:model]    = Module
    ctx[:contract] = Integer
    ctx[:model]   .must_equal Module
    ctx[:contract].must_equal Integer

    # it {  }
    immutable.inspect.must_equal %{{:repository=>\"User\"}}



    # strip mutable, build new one
    _original, _mutable = nil, nil

    new_ctx = ctx.Unwrap do |original, mutable| # both structures should be read-only
      _original, _mutable = original, mutable

      original.merge( a: mutable[:model] )
    end # this is our output, what do we want to tell the outer world?

    # it {  }
    _original.must_equal({:repository=>"User"})
    _mutable.must_equal({model: Module, contract: Integer})

    new_ctx[:current_user] = Class
    new_ctx[:current_user].must_equal Class

     # it {  }
    immutable.inspect.must_equal %{{:repository=>\"User\"}}
    ctx.to_hash.must_equal( {:repository=>"User", :model=>Module, contract: Integer } )

    # it {  }
    new_ctx.to_hash.must_equal({ :repository=>"User", a: Module, current_user: Class })
  end

  #- #to_hash
  it do
    ctx = Trailblazer::Context( immutable )

    # it {  }
    ctx.to_hash.must_equal( { repository: "User" } )

    # last added has precedence.
    # only symbol keys.
    # it {  }
    ctx[:a] =Symbol
    ctx["a"]=String

    ctx.to_hash.must_equal({ :repository=>"User", :a=>String })
  end





  #-
  it do
    immutable = { repository: "User", model: Module, current_user: Class }

    ctx = Trailblazer::Context(immutable) do |original, mutable|
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

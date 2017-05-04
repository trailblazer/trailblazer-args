# "di" step_di: order:  1. runtime, 2. { contract.class: A } (dynamic at runtime?)


# TODO: mark/make all but mutable_options as frozen.
# The idea of Skill is to have a generic, ordered read/write interface that
# collects mutable runtime-computed data while providing access to compile-time
# information.
# The runtime-data takes precedence over the class data.
module Trailblazer
  # Holds local options (aka `mutable_options`) and "original" options from the "outer"
  # activity (aka wrapped_options).

  # only public creator: Build
  class Context # :data object:
    def initialize(wrapped_options)
      @mutable_options, @wrapped_options = {}, wrapped_options
    end

    def [](name)
      @mutable_options[name] || @wrapped_options[name]
    end

    def []=(name, value)
      @mutable_options[name] = value
    end

    # Return the Context's two components. Used when computing the new output for
    # the next activity.
    def decompose
      # it would be cool if that could "destroy" the original object.
      # also, if those hashes were immutable, that'd be amazing.
      [ @wrapped_options, @mutable_options ]
    end


    def self.Build(wrapped_options, mutable_options={})
      wrapped_options = yield(wrapped_options, mutable_options) if block_given?
      new(wrapped_options)
    end

    # Context object as a new activity input. Optional new_hash
    Input = ->(original_ctx, new_hash={}, &block) do

    end
  end


  class Options
    def initialize(*containers)
      @mutable_options = {}
      @containers      = containers
      @resolver        = Resolver.new(@mutable_options, *containers)
    end

    def [](name)
      @resolver[name]
    end

    def []=(name, value)
      @mutable_options[name] = value
    end

    # THIS METHOD IS CONSIDERED PRIVATE AND MIGHT BE REMOVED.
    # Options from ::call (e.g. "user.current"), containers, etc.
    # NO mutual data from the caller operation. no class state.
    # --------==> this always returned an array of "hashes".
    def to_runtime_data
      @containers.slice(1..-2)
    end

    # Returns all data that has been written to this object via Options#[]= since
    # its instantiation.
    def to_mutable_data
      @mutable_options
    end

    # Returns the list of data that was passed to the constructor and hence was readable,
    # but not writeable.
    def to_containers
      @containers
    end

    def to_options(proc=nil)
      raise if proc
      self.class.new(*@containers)
    end

    # Called when Ruby transforms options into kw args, via **options.
    # TODO: this method has massive potential for speed improvements.
    # The `tmp_options` argument is experimental. It allows adding temporary options
    # to the kw args.
    #:private:
    def to_hash(tmp_options={})
      {}.tap do |h|
        arr = to_runtime_data << to_mutable_data << tmp_options

        arr.each { |hsh|
          hsh.each { |k, v| h[k.to_sym] = v }
        }
      end
    end

    # Look through a list of containers until you find the skill.
    class Resolver
    # alternative implementation:
    # containers.reverse.each do |container| @mutable_options.merge!(container) end
    #
    # benchmark, merging in #initialize vs. this resolver.
    #                merge     39.678k (± 9.1%) i/s -    198.700k in   5.056653s
    #             resolver     68.928k (± 6.4%) i/s -    342.836k in   5.001610s
      def initialize(*containers)
        @containers = containers
      end

      def [](name)
        @containers.find { |container| container.key?(name) && (return container[name]) }
      end
    end

    # private API.
    def inspect
      "<Skill #{@resolver.instance_variable_get(:@containers).collect { |c| c.inspect }.join(" ")}>"
    end
  end
end

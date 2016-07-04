# frozen_string_literal: true
module MFP
  class Struct
    class Parser
      include Anima.new(:fields, :input), Procto.call(:parse)

      def parse
        string = input

        state =
          fields.reduce(State.new({})) do |parse_state, (name, type)|
            data, string = *type.parse(string, state: parse_state)

            parse_state.add(name, data)
          end

        ParsedData.new(state.to_h, string)
      end

      class State
        include Concord.new(:attributes)

        def to_h
          attributes
        end

        def read(name)
          attributes.fetch(name)
        end

        def add(name, value)
          self.class.new(attributes.merge(name => value))
        end
      end # State
      private_constant(:State)
    end # Parser

    include Anima.new, Adamantium, AbstractType

    UNDEFINED = Object.new.freeze
    private_constant(:UNDEFINED)

    class << self
      attr_reader :parts, :defaults
    end

    def self.inherited(base)
      base.class_eval do
        @parts    = {}
        @defaults = {}
      end
    end

    def self.field(name, type, default: UNDEFINED)
      @parts[name]    = type
      @defaults[name] = default unless default.equal?(UNDEFINED)

      include anima.add(name)
    end
    private_class_method :field

    def self.parse(string, **)
      attributes, remainder = *Parser.call(fields: parts, input: string)

      ParsedData.new(build(attributes), remainder)
    end

    def self.build(*arguments)
      new(*arguments)
    end

    def initialize(attributes)
      super(self.class.defaults.merge(attributes))
    end

    def to_s
      values.join
    end

    def to_hash
      to_h
    end

    private

    def values
      self.class.parts.map { |name, type| type.build(public_send(name)) }
    end
  end # Struct
end # MFP

# frozen_string_literal: true
module MFP
  class Type
    include AbstractType, Concord.new(:value)

    abstract_singleton_method :parse

    def self.build(value)
      new(value)
    end

    abstract_method :to_s

    class Numeric < self
      include AbstractType

      def self.parse(string, **)
        part      = string.slice(0, self::SIZE)
        remainder = string.slice(self::SIZE, string.size)

        ParsedData.new(*part.unpack(self::PACK_TEMPLATE), remainder)
      end

      def to_s
        [value].pack(self.class::PACK_TEMPLATE)
      end
    end # Numeric

    class Short < Numeric
      SIZE          = 2
      PACK_TEMPLATE = 's>'
    end # Short

    class Int < Numeric
      SIZE          = 4
      PACK_TEMPLATE = 'l>'
    end # Int

    class Quad < Numeric
      SIZE          = 8
      PACK_TEMPLATE = 'q>'
    end # Quad

    class Float < Numeric
      SIZE          = 4
      PACK_TEMPLATE = 'g'
    end # Float

    class String < self
      def self.parse(string_with_size, **)
        size, string = *Short.parse(string_with_size)
        part         = string.slice(0, size)
        remainder    = string.slice(size, string.size)

        ParsedData.new(part, remainder)
      end

      def to_s
        "#{size}#{value}"
      end

      private

      # 16-bit big-endian int
      def size
        Short.new(value.size)
      end
    end # String

    class Date < self
      def self.parse(string, **)
        part = string.slice(0, 10)
        remainder = string.slice(10, string.size)

        ParsedData.new(::Date.iso8601(part), remainder)
      end

      def to_s
        value.iso8601
      end
    end # Date

    class UUID < self
      def self.parse(string, **)
        ParsedData.new(string.slice(0, 16), string.slice(16, string.size))
      end

      def to_s
        value
      end
    end # UUID

    class List
      include Concord.new(:members)

      def self.[](member_type)
        Definition.new(member_type)
      end

      def to_s
        data = members.join
        "#{Short.new(members.size)}#{data}"
      end

      class Definition
        include Concord.new(:type)

        def parse(string_with_size, **)
          size, string = *Short.parse(string_with_size)

          members =
            Array.new(size) do
              member, string = *type.parse(string)

              member
            end

          ParsedData.new(List.new(members), string)
        end

        def build(array)
          array
        end
      end # Definition
      private_constant(:Definition)
    end # List

    class Hash < self
      abstract_singleton_method :parse

      def self.parse_with_size(size, string)
        hash =
          size.times.with_object({}) do |*, object|
            key, string   = *String.parse(string)
            value, string = *String.parse(string)

            object[key] = value
          end

        ParsedData.new(hash, string)
      end
      private_class_method :parse_with_size

      def to_s
        value.flatten.map(&String.method(:new)).join
      end
    end # Hash

    module Domain
      # Other hash types we handle define the size right before the data itself:
      #
      #     ┌──────────────────┐
      #     │       ...        │
      #     ├──────────────────┤
      #     │   object_size    │
      #     ├──────────────────┤
      #     │      object      │
      #     ├──────────────────┤
      #     │       ...        │
      #     └──────────────────┘
      #
      # For some reason the size of the `last_sync` object is separated from
      # the actual hash like so
      #
      #     ┌──────────────────┐
      #     │       ...        │
      #     ├──────────────────┤
      #     │  last_sync_size  │
      #     ├──────────────────┤
      #     │ [unrelated data] │
      #     ├──────────────────┤
      #     │    last_sync     │
      #     ├──────────────────┤
      #     │       ...        │
      #     └──────────────────┘
      #
      # so it requires a custom type handler
      class LastSync < Type::Hash
        def self.parse(string, state:)
          parse_with_size(state.read(:sync_pointer_count), string)
        end
      end # LastSync
    end # Domain
  end # Type
end # MFP

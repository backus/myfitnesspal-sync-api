# frozen_string_literal: true
module MFP
  class PacketHeader < Struct
    field :magic_number, Type::Short
    field :length,       Type::Int
    field :unknown1,     Type::Short
    field :packet_type,  Type::Short
  end # PacketHeader
end # MFP

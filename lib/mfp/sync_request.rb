# encoding: ASCII-8BIT
# frozen_string_literal: true

module MFP
  class SyncRequest < Struct
    UUID = "\xD5\xFB\x9F8\xE9\xB9K_\x8F\xEE\x9E\x9D\xBA-@\x88"

    field :magic_number,         Type::Short,   default: 0x04D3
    field :packet_size,          Type::Int,     default: 0 # Requests still work if left as 0
    field :unknown_header_value, Type::Short,   default: 1
    field :packet_type,          Type::Short,   default: 1
    field :api_version,          Type::Short,   default: 6
    field :svn_revision,         Type::Int,     default: 237
    field :unknown_body_value,   Type::Short,   default: 2
    field :username,             Type::String
    field :password,             Type::String
    field :flags,                Type::Short,   default: 0x5
    field :installation_uuid,    Type::UUID,    default: UUID
    field :last_sync_count,      Type::Short,   default: 0
  end # SyncRequest
end # MFP

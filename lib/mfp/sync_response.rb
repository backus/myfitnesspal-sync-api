# frozen_string_literal: true
module MFP
  class SyncResponse < Struct
    field :status_code,            Type::Short
    field :error_message,          Type::String
    field :optional_extra_message, Type::String
    field :master_id,              Type::Int
    field :flags,                  Type::Short
    field :sync_pointer_count,     Type::Short
    field :expected_packet_count,  Type::Int
    field :last_sync,              Type::Domain::LastSync
  end # SyncResponse
end # MFP

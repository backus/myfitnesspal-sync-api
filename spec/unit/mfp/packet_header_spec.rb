# frozen_string_literal: true
RSpec.describe MFP::PacketHeader do
  let(:struct) do
    described_class.build(
      magic_number: 0x04D3,
      length:       243,
      unknown1:     1,
      packet_type:  2
    )
  end

  let(:raw) { sync_response.slice(0, 10) }

  it_behaves_like 'a packet struct'
end

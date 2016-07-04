# frozen_string_literal: true
require 'pathname'

RSpec.shared_context 'a packet struct' do
  let(:sync_response) { MFPSpec::SYNC_RESPONSE_FIXTURE }
  let(:parsed_data)   { described_class.parse(raw)     }

  it 'serializes' do
    expect(raw).to start_with(struct.to_s)
  end

  it 'extracts data' do
    expect(parsed_data.data).to eql(struct)
  end

  it 'exposes remainder of unparsed input' do
    expect(raw.slice(struct.to_s.size, raw.size)).to eql(parsed_data.remainder)
  end
end

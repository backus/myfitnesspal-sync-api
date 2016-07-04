# encoding: ASCII-8BIT
# frozen_string_literal: true

RSpec.describe MFP::SyncRequest do
  let(:struct) do
    described_class.build(
      username: 'johndoe',
      password: 'letmein'
    )
  end

  let(:raw) { MFPSpec::SYNC_REQUEST_FIXTURE }

  it_behaves_like 'a packet struct'
end

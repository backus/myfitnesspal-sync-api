# encoding: ASCII-8BIT
# frozen_string_literal: true

RSpec.describe MFP::Request do
  subject(:request) do
    described_class.new(
      body:     body,
      boundary: boundary
    ).to_s
  end

  let(:boundary) { 'this_is_the_BOUNDARY' }

  let(:body) do
    instance_double(MFP::SyncRequest, to_s: 'wow')
  end

  it 'constructs request and interpolates body' do
    expect(request).to eql(<<~REQUEST)
    --this_is_the_BOUNDARY\r
    Content-Disposition: form-data; name="syncdata"; filename="syncdata.dat"\r
    Content-Type: application/octet-stream\r\n\r
    wow\r
    --this_is_the_BOUNDARY--\r
    REQUEST
  end

  context 'with the sync body' do
    let(:body) do
      MFP::SyncRequest.new(
        username: 'johndoe',
        password: 'letmein'
      )
    end

    let(:boundary) do
      'clevphexxswwkcxwztziqmculljsebzaeeloxdhidnitybtmcnbhmqzvpqfvpimynaenmqldvwkjxg'
    end

    let(:expected) do
      <<~REQUEST
      --clevphexxswwkcxwztziqmculljsebzaeeloxdhidnitybtmcnbhmqzvpqfvpimynaenmqldvwkjxg\r
      Content-Disposition: form-data; name="syncdata"; filename="syncdata.dat"\r
      Content-Type: application/octet-stream\r\n\r
      \x04\xD3\x00\x00\x00\x00\x00\x01\x00\x01\x00\x06\x00\x00\x00\xED\x00\x02\x00\07johndoe\x00\x07letmein\x00\x05\xD5\xFB\x9F8\xE9\xB9K_\x8F\xEE\x9E\x9D\xBA-@\x88\x00\x00\r
      --clevphexxswwkcxwztziqmculljsebzaeeloxdhidnitybtmcnbhmqzvpqfvpimynaenmqldvwkjxg--\r
      REQUEST
    end

    it { should eql(expected) }
  end
end

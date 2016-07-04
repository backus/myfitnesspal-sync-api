# frozen_string_literal: true
RSpec.describe MFP::Struct do
  let(:fake_sync) do
    FakeSync.build(
      sync_pointer_count: 1,
      last_sync:          { 'foo' => 'hi' },
      sibling:            FakeSibling.build(some_string: 'baz'),
      child:              MFP::Type::List.new([
        FakeChild.build(some_number: 42),
        FakeChild.build(some_number: 43)
      ])
    )
  end

  let(:binary) do
    [
      "\x00\x04", # String length
      'Blah',
      "\x00\x01", # sync_pointer_count
      "\x00\x03", # String length
      'foo',
      "\x00\x02", # String length
      'hi',
      "\x00\x03", # String length
      'baz',
      "\x00\x02", # array size
      "\x00\x2a", # some_number for child #1
      "\x00\x2b"  # some_number for child #2
    ].join
  end

  before do
    stub_const('FakeSync', Class.new(described_class))
    stub_const('FakeSibling', Class.new(described_class))
    stub_const('FakeChild', Class.new(described_class))

    class FakeChild
      field :some_number, MFP::Type::Short
    end # FakeChild

    class FakeSibling
      field :some_string, MFP::Type::String
    end # FakeSibling

    class FakeSync
      field :some_string,        MFP::Type::String, default: 'Blah'
      field :sync_pointer_count, MFP::Type::Short
      field :last_sync,          MFP::Type::Domain::LastSync
      field :sibling,            FakeSibling
      field :child,              MFP::Type::List[FakeChild]
    end # FakeSync
  end

  it 'serializes struct into binary format' do
    expect(fake_sync.to_s).to eql(binary)
  end

  it 'parses binary format into a struct' do
    expect(FakeSync.parse(binary).data).to eql(fake_sync)
  end

  it 'provides remaining unparsed portion of string' do
    extra = 'some_junk'

    expect(FakeSync.parse(binary + extra).remainder).to eql(extra)
  end

  it 'implicitly converts into a hash' do
    expect(fake_sync.to_hash).to eql(
      some_string:        'Blah',
      sync_pointer_count: 1,
      last_sync:          { 'foo' => 'hi' },
      sibling:            FakeSibling.build(some_string: 'baz'),
      child:              MFP::Type::List.new([
        FakeChild.build(some_number: 42),
        FakeChild.build(some_number: 43)
      ])
    )
  end

  it 'does not set defaults for all attributes' do
    expect { FakeSync.build({}) }.to raise_error(Anima::Error)
  end

  context 'default values' do
    before do
      stub_const('MyStruct', Class.new(described_class))

      class MyStruct
        field :null_value, MFP::Type::Short, default: nil
      end # MyStruct
    end

    it 'supports setting nil as a default value' do
      expect(MyStruct.new({}).null_value).to be(nil)
    end
  end
end

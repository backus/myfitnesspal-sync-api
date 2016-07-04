# frozen_string_literal: true
RSpec.describe MFP::SyncResponse do
  let(:struct) do
    described_class.build(
      status_code:            0,
      error_message:          '',
      optional_extra_message: '',
      master_id:              114_885_321,
      flags:                  0,
      sync_pointer_count:     6,
      expected_packet_count:  4,
      last_sync:              {
        'user_property' => '2016-07-05 03:24:13 UTC',
        'user_status'   => '2016-07-05 03:24:16 UTC',
        'food_entry'    => '5583558402',
        'water_entry'   => '2016-07-05 06:42:15 UTC',
        'measurement'   => '2016-07-05 03:24:13 UTC',
        'diary_note'    => '2016-07-05 06:42:15 UTC'
      }
    )
  end

  let(:raw) { sync_response.slice(10, sync_response.size) }

  it_behaves_like 'a packet struct'
end

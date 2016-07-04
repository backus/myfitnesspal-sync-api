# frozen_string_literal: true
RSpec.describe MFP::Response do
  let(:packets)  { described_class.call(response) }
  let(:response) { MFPSpec::SYNC_RESPONSE_FIXTURE }

  let(:sync_response) do
    MFP::SyncResponse.build(
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

  let(:food_entry) do
    MFP::FoodEntry.new(
      master_food_id: 5_583_558_402,
      food:           MFP::Food.new(
        master_food_id:       192_709_517,
        owner_user_master_id: 3,
        original_master_id:   188_901_291,
        description:          'Cheesburger',
        brand:                "Mcdonald's",
        flags:                1,
        calories:             300.0,
        fat:                  12.0,
        saturated_fat:        6.0,
        polyunsaturated_fat:  0.0,
        monounsaturated_fat:  0.0,
        trans_fat:            0.5,
        cholesterol:          40.0,
        sodium:               680.0,
        potassium:            0.0,
        carbohydrates:        33.0,
        fiber:                2.0,
        sugar:                7.0,
        protein:              15.0,
        vitamin_a:            6.0,
        vitamin_c:            2.0,
        calcium:              20.0,
        iron:                 15.0,
        grams:                1.0,
        type:                 0,
        portions:             MFP::Type::List.new([
          MFP::FoodPortion.new(
            amount:       4.0,
            gram_weight:  1.0,
            description:  'oz',
            fraction_int: 0
          ),
          MFP::FoodPortion.new(
            amount:       1.0,
            gram_weight:  0.25,
            description:  'oz',
            fraction_int: 0
          ),
          MFP::FoodPortion.new(
            amount:       113.0,
            gram_weight:  0.9964900016784668,
            description:  'gram',
            fraction_int: 0
          ),
          MFP::FoodPortion.new(
            amount:       1.0,
            gram_weight:  0.008818499743938446,
            description:  'gram',
            fraction_int: 0
          )
        ])
      ),
      date:           Date.new(2016, 7, 4),
      meal_name:      'Breakfast',
      quality:        1.0,
      weight_index:   0
    )
  end

  it 'returns an array with a sync response and food_entry' do
    expect(packets).to eql([sync_response, food_entry])
  end
end

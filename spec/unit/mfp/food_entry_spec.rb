
# frozen_string_literal: true
RSpec.describe MFP::FoodEntry do
  let(:struct) do
    described_class.build(
      master_food_id: 5_270_967_843,
      food:           MFP::Food.build(
        master_food_id:       66_482_060,
        owner_user_master_id: 38_416_805,
        original_master_id:   66_482_060,
        description:          'Bacon, Egg and Cheeseburger',
        brand:                '',
        flags:                3,
        calories:             970.0,
        fat:                  65.0,
        saturated_fat:        30.0,
        polyunsaturated_fat:  -1.0,
        monounsaturated_fat:  -1.0,
        trans_fat:            2.0,
        cholesterol:          375.0,
        sodium:               1380.0,
        potassium:            -1.0,
        carbohydrates:        45.0,
        fiber:                3.0,
        sugar:                6.0,
        protein:              52.0,
        vitamin_a:            -1.0,
        vitamin_c:            -1.0,
        calcium:              -1.0,
        iron:                 -1.0,
        grams:                1.0,
        type:                 0,
        portions:             MFP::Type::List.new([
          MFP::FoodPortion.new(
            amount:       1.0,
            gram_weight:  1.0,
            description:  'Burger',
            fraction_int: 0
          )
        ])
      ),
      date:           Date.new(2016, 1, 17),
      meal_name:      'Lunch',
      quality:        1.0,
      weight_index:   0
    )
  end

  let(:raw) { MFPSpec::FOOD_ENTRY_FIXTURE }

  it_behaves_like 'a packet struct'
end

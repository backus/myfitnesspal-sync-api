# frozen_string_literal: true
module MFP
  class FoodPortion < Struct
    field :amount,       Type::Float
    field :gram_weight,  Type::Float
    field :description,  Type::String
    field :fraction_int, Type::Short
  end # FoodPortion
end # MFP

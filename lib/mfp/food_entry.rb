# frozen_string_literal: true
module MFP
  class FoodEntry < Struct
    field :master_food_id, Type::Quad
    field :food,           Food
    field :date,           Type::Date
    field :meal_name,      Type::String
    field :quality,        Type::Float
    field :weight_index,   Type::Int
  end # FoodEntry
end # MFP

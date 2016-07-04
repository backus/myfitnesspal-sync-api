# frozen_string_literal: true
module MFP
  class Response
    include Concord.new(:raw), Procto.call(:read)

    RESPONSE_TYPES = IceNine.deep_freeze(
      2 => SyncResponse,
      5 => FoodEntry
    )

    UNSUPPORTED = IceNine.deep_freeze([
      1,  # sync_request
      3,  # food
      4,  # exercise
      6,  # exercise_entry
      7,  # client_food_entry
      8,  # client_exercise_entry
      9,  # measurement_types
      10, # measurement_value
      11, # meal_ingredients
      12, # master_id_assignment
      13, # user_property_update
      14, # user_registration
      16, # water_entry
      17, # delete_item
      18, # search_request
      19, # search_response
      20, # failed_item_creation
      21, # add_deleted_most_used_food
      23  # diary_note
    ])

    def read
      parsed_data =
        packets.map do |packet_type, packet|
          next if UNSUPPORTED.include?(packet_type)

          RESPONSE_TYPES.fetch(packet_type).parse(packet).data
        end

      parsed_data.compact
    end

    private

    def packets
      return to_enum(__method__) unless block_given?

      remainder = raw

      until remainder.empty?
        header, remainder = *PacketHeader.parse(remainder)

        yield(header.packet_type, remainder)

        remainder = remainder.slice(header.length - 10, remainder.size)
      end
    end
  end # Response
end # MFP

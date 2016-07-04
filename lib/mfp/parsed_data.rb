# frozen_string_literal: true
module MFP
  class ParsedData
    include Concord::Public.new(:data, :remainder), Adamantium

    def to_a
      [data, remainder]
    end
  end # ParsedData
end # MFP

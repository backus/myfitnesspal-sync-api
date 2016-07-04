# frozen_string_literal: true
require 'mfp'

require_relative './support/struct_behavior'

module MFPSpec
  SYNC_RESPONSE_FIXTURE =
    Pathname.new(__dir__)
      .join('fixtures/response.bin')
      .expand_path
      .read
      .force_encoding('ASCII-8BIT')

  FOOD_ENTRY_FIXTURE =
    Pathname.new(__dir__)
      .join('fixtures/food_entry.bin')
      .expand_path
      .read
      .force_encoding('ASCII-8BIT')

  SYNC_REQUEST_FIXTURE =
    Pathname.new(__dir__)
      .join('fixtures/sync_request.bin')
      .expand_path
      .read
      .force_encoding('ASCII-8BIT')
end # MFPSpec

RSpec.configuration.around do |example|
  Timeout.timeout(0.1, &example)
end

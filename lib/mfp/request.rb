# frozen_string_literal: true
module MFP
  class Request
    include Anima.new(:body, :boundary)

    TEMPLATE = <<~FORMAT.gsub("\n", "\r\n")
    --%<boundary>s
    Content-Disposition: form-data; name="syncdata"; filename="syncdata.dat"
    Content-Type: application/octet-stream

    %<body>s
    --%<boundary>s--
    FORMAT

    def to_s
      format(
        TEMPLATE,
        boundary: boundary,
        body:     body
      )
    end
  end # Request
end # MFP

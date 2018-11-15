# frozen_string_literal: true

module Barong
  module JWT
    class Session < Base
      SUBJECT = 'session'

      def merge_claims(payload)
        super(payload).merge(
          sub: SUBJECT,
          aud: @options[:aud]
        )
      end
    end
  end
end


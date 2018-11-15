# frozen_string_literal: true

module Barong
  module JWT
    class Base
      DEFAULT_OPTIONS = {
        algorithm: 'RS256',
        iss: 'barong'
      }

      def initialize(private_key, options = {})
        @private_key = private_key
        @options = options.merge(DEFAULT_OPTIONS)
      end

      def encode(payload)
        ::JWT.encode(merge_claims(payload),
                     @private_key, @options[:algoritm])
      end

      def merge_claims(payload)
        payload.merge(
          aud: @options[:aud],
          iss: @options[:iss],
          jti: SecureRandom.hex(10),
          iat: Time.now.to_i,
          exp: (Time.now + @options[:expire]).to_i
        )
      end
    end
  end
end
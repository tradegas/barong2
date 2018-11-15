# frozen_string_literal: true

module API::V2
  module Identity
    module Utils

      def session
        request.session
      end

      def codec
        @_codec ||= Barong::JWT.new(key: Barong::App.config.keystore.private_key)
      end

      def verify_captcha!(user:, response:, error_statuses: [400, 422])
        captcha_error_message = 'reCAPTCHA verification failed, please try again.'
        error!('recaptcha_response is required', error_statuses.first) if response.blank?
        return if RecaptchaVerifier.new(request: request).verify_recaptcha(model: user,
                                                                          skip_remote_ip: true,
                                                                          response: response)
        error!(captcha_error_message, error_statuses.last)
      rescue StandardError
        error!(captcha_error_message, error_statuses.last)
      end

      def apiKey_headers?
        return false if headers['X-Auth-Apikey'].nil? &&
                        headers['X-Auth-Nounce'].nil? &&
                        headers['X-Auth-Signature'].nil?
        error!('Request contains invalid or blank api key headers!') unless headers['X-Auth-Apikey'] &&
                                                                            headers['X-Auth-Nounce'] &&
                                                                            headers['X-Auth-Signature']
        true
      end

      def apiKey_params
        params = {}
        params.merge(
          'kid': headers['X-Auth-Apikey'],
          'nounce': headers['X-Auth-Nounce'],
          'signature':  headers['X-Auth-Signature']
        )
      end
    end
  end
end

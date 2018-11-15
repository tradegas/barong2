# frozen_string_literal: true

module API::V2
  module Identity
    class Users < Grape::API

      desc 'User related routes'
      resource :users do
        desc 'Creates new user',
        success: { code: 201, message: 'Creates new user' },
        failure: [
          { code: 400, message: 'Required params are missing' },
          { code: 422, message: 'Validation errors' }
        ]
        params do
          requires :email, type: String, desc: 'User Email', allow_blank: false
          requires :password, type: String, desc: 'User Password', allow_blank: false
          requires :recaptcha_response, type: String, desc: 'Response from Recaptcha widget'
        end
        post do
          # WIP: by default after creation
          # we hardcode 'active' for user creation for now, since we dont have confirmation logic for now
          active_user_params =  params.slice('email', 'password').merge!(state: "active")
          user = User.new(active_user_params)
          verify_captcha!(user: user,
                          response: params['recaptcha_response'])

          error!(user.errors.full_messages, 422) unless user.save
        end

        desc 'Confirms an account',
             success: { code: 201, message: 'Confirms an account' },
             failure: [
               { code: 400, message: 'Required params are missing' },
               { code: 422, message: 'Validation errors' }
             ]
        params do
          requires :confirmation_token, type: String,
                                        desc: 'Token from email',
                                        allow_blank: false
        end
        post '/confirm' do
          # validate JWT
          if user.errors.any?
            error!(user.errors.full_messages.to_sentence, 422)
          end
        end

        desc 'Send confirmations instructions',
             security: [{ "BearerToken": [] }]
        params do
          requires :email, type: String,
                           desc: 'Account email',
                           allow_blank: false
        end
        post '/generate_confirmation_instructions' do
          # generate JWT
          if user.errors.any?
            error!(user.errors.full_messages.to_sentence, 422)
          end

          { message: 'Confirmation instructions was sent successfully' }
        end

      end
    end
  end
end

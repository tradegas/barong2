# frozen_string_literal: true

module API::V2
  module Resource
    class Users < Grape::API
      resource :users do
        desc 'Returns current user'
        get '/me' do
          current_user.attributes.except('password_digest')
        end

        desc 'Returns user activity'
        params do
          requires :category, type: String,
                              allow_blank: false,
                              desc: 'Category of user activity. Allowed: [all, password, session, otp]'
        end
        get '/activity/:category' do
          user_activity
        end
      end
    end
  end
end

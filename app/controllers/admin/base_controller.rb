# encoding: UTF-8
# frozen_string_literal: true

require_dependency 'authorization/bearer'

module Admin
    class BaseController < ApplicationController
      include Authorization::Bearer

      layout 'admin'
  
      before_action :authenticate_admin

      def authenticate_admin
        if request.headers['Authorization']
          token = request.headers['Authorization']
          unless token.include?('Bearer')
            token = 'Bearer ' + token
          end
          payload = authenticate!(token)
          is_admin(payload)
        else
          raise(Peatio::Auth::Error, 'Authorization token should be included in the request!')
        end
      end

      def is_admin(payload)
        unless User.find_by_email(payload[:email]).role == 'admin'
          raise(Peatio::Auth::Error, "You're not an admin, so not allowed to access this resource")
        end
      end

    end
  end
  
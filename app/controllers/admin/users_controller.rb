# frozen_string_literal: true

module Admin
    class UsersController < BaseController
      before_action :find_user, except: :index
  
      def index
        @users = User.page(params[:page])
      end
  
      def show
        @profile = @user.profile
        @documents = @user.documents
        @labels = @user.labels
        @phones = @user.phones
        @document_label_value = document_label&.value
      end
  
      def edit
      end
  
      def update
        @user.update!(user_params)
        redirect_to admin_users_url
      end
  
      def destroy
        ## TODO: Implement discard method
        @user.destroy
        respond_to do |format|
          format.html { redirect_to admin_users_url, notice: 'Account is marked as discarded' }
        end
      end
  
      def disable_2fa
        @user.update!(otp: false)
        redirect_to action: :show
      end
  
    private
  
      def find_user
        @user = User.find(params[:id])
      end
  
      def document_label
        @user.labels.find_by(key: 'document', scope: 'private')
      end
  
      def user_params
        params.require(:user).permit(:role)
      end
    end
  end
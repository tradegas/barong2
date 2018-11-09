# frozen_string_literal: true

module Admin
    class LabelsController < BaseController
      before_action :find_user
      before_action :find_label, only: %i[edit update destroy]
  
      def new
        @label = @user.labels.new
      end
  
      def create
        @label = @user.labels.new(label_params)
  
        if @label.save
          redirect_to admin_user_path(@user), notice: 'Label was successfully created.'
        else
          render :new
        end
      end
  
      def edit
      end
  
      def update
        if @label.update(label_params)
          redirect_to admin_user_path(@user), notice: 'Label was successfully updated.'
        else
          render :edit
        end
      end
  
      def destroy
        @label.destroy!
        redirect_to admin_user_path(@user), notice: 'Label was successfully destroyed.'
      end
  
    private
  
      def find_user
        @user = User.find(params[:user_id])
      end
  
      def find_label
        @label = @user.labels.find(params[:id])
      end
  
      def label_params
        params.require(:label).permit(:key, :value, :scope)
      end
    end
  end
  
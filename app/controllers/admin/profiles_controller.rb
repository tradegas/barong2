# frozen_string_literal: true

module Admin
  class ProfilesController < BaseController
    before_action :find_profile

    def edit
    end

    def update
      if @profile.update(profile_params)
        redirect_to admin_user_path(@profile.user),
                    notice: 'Profile was successfully updated.'
      else
        render :edit
      end
    end

    def document_label
      user = @profile.user
      if user.add_level_label(:document, params[:state])
        flash[:notice] = 'Document label was successfully updated.'
      end

      redirect_to admin_user_path(@profile.user)
    end

  private

    def find_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile)
            .permit(:first_name, :last_name,
                    :dob, :address, :postcode, :city, :country)
    end
  end
end

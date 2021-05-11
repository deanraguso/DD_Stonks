class FavoritesController < ApplicationController
    before_action :signed_id_redirect

    def show
    end

    def add
        p params[:favorites]
        current_user.update(
            favorites: current_user.favorites +
            params[:favorites]
        )
        redirect_back(fallback_location: root_path) 
    end

    def delete
    end

    def erase
    end

    private

    def signed_id_redirect
        if user_signed_in?
            @user = current_user
        else    
            redirect_to new_user_session_path
        end
    end
end

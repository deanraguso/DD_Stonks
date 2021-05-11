require 'json'
class FavoritesController < ApplicationController
    before_action :signed_id_redirect

    def show
        @results = current_user.favorites
    end

    def add
        current_user.update(
            favorites: current_user.favorites || []
        )
        current_user.update(
            favorites: current_user.favorites +
            params[:favorites]
        )
        redirect_back(fallback_location: root_path) 
    end

    def delete
        current_user.update(
            favorites: current_user.favorites.select! {
            |fav| 
                JSON.parse(fav)["name"] != 
                JSON.parse(params[:favorites][0])["name"]
            }
        )
        redirect_back(fallback_location: root_path) 
    end

    def erase
        current_user.update(
            favorites: []
        )
        redirect_back(fallback_location: root_path) 
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

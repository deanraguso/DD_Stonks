class FavoritesController < ApplicationController
    before_action :signed_id_redirect

    def show
    end

    def add
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

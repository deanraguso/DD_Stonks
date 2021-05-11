class FavoritesController < ApplicationController

    def show

    end

    def add

    end

    def delete

    end

    def erase

    end

    private 

    def user
        user = User.find_by(id: params.require(:id))
    end
end

class MoviesController < ApplicationController

 def index
    @user = User.find(session[:user_id])
    if params[:search] == ""
      redirect_to discover_users_path
      flash[:alert] = "Search Field Can't Be Blank"
    else
      @movies = if params[:search]
                  MoviesFacade.searched_movies(params[:search])
                else
                  MoviesFacade.top_rated_movies
                end
    end
  end

  def show
    @movie = MoviesFacade.movie_details(params[:id])
  end
end

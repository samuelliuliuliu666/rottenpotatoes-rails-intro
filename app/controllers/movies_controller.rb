class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = @all_ratings
    selection = nil 
    if params[:ratings]
      selection = params[:ratings].keys
      session[:ratings] = selection
      session[:full_ratings] = params[:ratings]
      @ratings_to_show = selection
    end
    if params.has_key?(:ratings_to_show)
      session[:ratings] = params[:ratings_to_show]
    end 
    @ratings_to_show = session[:ratings]
    session[:sort_by_col] = params[:sort_by_col] if params.has_key?(:sort_by_col)

    if session[:sort_by_col]
      if session[:sort_by_col] == 'title'
        @title_header = 'hilite bg-warning'
      elsif session[:sort_by_col] == 'release_date'
        @release_header = 'hilite bg-warning'
      end
    end
    @movies = Movie.with_ratings(session[:sort_by_col],@ratings_to_show)

    if not params[:ratings] and not params[:sort_by_col]
      if (session[:full_ratings]) and (not session[:sort_by_col])
        redirect_to movies_path(:ratings=>session[:full_ratings])
      elsif (not session[:full_ratings]) and (session[:sort_by_col])
        redirect_to movies_path(:sort_by_col=>session[:sort_by_col])
      elsif session[:full_ratings] and session[:sort_by_col]
        redirect_to movies_path(:ratings=>session[:full_ratings],:sort_by_col=>session[:sort_by_col])
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

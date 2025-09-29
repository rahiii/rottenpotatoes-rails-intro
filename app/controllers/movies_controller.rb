class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    # Check if user is providing new filter/sort parameters
    if params.key?(:ratings) || params.key?(:sort_by)
      # User is actively filtering/sorting - save current settings to session
      @ratings_to_show = params[:ratings].present? ? params[:ratings].keys : []
      @sort_by = params[:sort_by]
      
      # Save to session (convert array to hash for session storage compatibility)
      session[:ratings] = @ratings_to_show.empty? ? {} : Hash[@ratings_to_show.map { |r| [r, '1'] }]
      session[:sort_by] = @sort_by
    else
      # User navigated back without params - restore from session
      if session[:ratings].present?
        @ratings_to_show = session[:ratings].keys
      else
        @ratings_to_show = @all_ratings  # Default to all ratings
        session[:ratings] = Hash[@all_ratings.map { |r| [r, '1'] }]
      end
      
      @sort_by = session[:sort_by]
    end

    # Filter and sort movies
    @movies = Movie.with_ratings(@ratings_to_show).sorted(@sort_by)
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

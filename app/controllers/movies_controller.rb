class MoviesController < ApplicationController
  def index
    @sorted = {}
    @all_ratings = Movie.ratings
    needs_to_redirect = false
    redirect_params = {}

    if params.has_key?(:ratings)
      session[:ratings] = params[:ratings]
      @checked_boxes = params[:ratings].keys
    elsif session.has_key?(:ratings)
      needs_to_redirect = true
    else
      @checked_boxes = @all_ratings
    end

    if params.has_key?(:sort_by)
      sort_by = session[:sort_by] = params[:sort_by]
    elsif session.has_key?(:sort_by)
      needs_to_redirect = true
    else
      sort_by = "id"
    end

    if needs_to_redirect
      redirect_params.merge!(ratings: session[:ratings])
      redirect_params.merge!(sort_by: session[:sort_by])
      flash.keep
      redirect_to movies_path(redirect_params)
    end

    @sorted[sort_by] = "hilite"

    @movies = Movie.where(rating: @checked_boxes).order(sort_by)
  end

  def show
    @movie = Movie.find params[:id]
  end

  def new
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was created successfully."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes! params[:movie]
    flash[:notice] = "#{@movie.title} was updated successfully."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted successfully."
    redirect_to movies_path
  end
end

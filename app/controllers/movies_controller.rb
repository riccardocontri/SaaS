class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.all_ratings
    #@movies = Movie.all :order => params[:order_by]
    #@movies = Movie.where :rating => params[:ratings].keys, :order => params[:order_by]
    @selected_ratings = [] if @selected_ratings.nil?
    @selected_ratings = params[:ratings].keys unless params[:ratings].nil?
    @movies = Movie.find_all_by_rating(@selected_ratings, :order => params[:order_by])
    @ordered_by = params[:order_by]
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.all_ratings

    #@selected_ratings = params[:ratings] unless params[:ratings].nil?
    @selected_ratings = (params[:ratings].nil?) ? session[:ratings] : params[:ratings]

    if @selected_ratings.nil?
        @selected_ratings = {}
        @all_ratings.each { |r| @selected_ratings[r] = 1 }
    end

    #@ordered_by = params[:order_by] unless params[:order_by].nil?
    @ordered_by = (params[:order_by].nil?) ? session[:order_by] : params[:order_by]

    @movies = Movie.find_all_by_rating(@selected_ratings.keys, :order => @ordered_by)

    session[:ratings] = @selected_ratings
    session[:order_by] = @ordered_by
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

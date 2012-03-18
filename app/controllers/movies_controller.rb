class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    redirect_needed = false

    @all_ratings = Movie.all_ratings

    if session[:ratings].nil?
        session[:ratings] = {}
        @all_ratings.each { |r| session[:ratings][r] = 1 }
    end

    if session[:order_by].nil?
        session[:order_by] = "title"
    end

    new_params = {}
    params.each { |key, val| new_params[key] = val }
    [:ratings, :order_by].each do |key|
        if params[key].nil?
            redirect_needed = true
            new_params[key] = session[key]
        else
            session[key] = params[key]
        end
    end

    if redirect_needed
        redirect_to movies_path(new_params)
    else
        @movies = Movie.find_all_by_rating(session[:ratings].keys, :order => session[:order_by])
    end
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

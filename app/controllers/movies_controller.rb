class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      reset
      
      # if @sorting_on_column
      #   @movies = Movie.with_ratings(@rating_param).order(@sorting_on_column)
      # end
      # if params[:sort] || params[:ratings]
      @sorting_on_column = sorting
      @rating_param = rate
      @rating_param ||= @all_ratings
      @rating_param = @rating_param.keys if @rating_param.respond_to?(:keys)
      @movies = Movie.where("rating IN (?)", @rating_param ).order(@sorting_on_column)

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
    def reset
      session[:sorting] = @sorting_on_column
      session[:rate] = @rating_param
    end
    
    def sorting
      return session[:sorting] if params[:sort].nil?
      session[:sorting] = params[:sort]
    end
    
    def rate 
      return session[:rating_param] if params[:ratings].nil?
      return session[:rating_param] = params[:ratings] if params[:ratings].is_a?(Array)
      session[:rating_param] = params[:ratings].keys
    end
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end

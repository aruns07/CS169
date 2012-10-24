class MoviesController < ApplicationController

  def index
    @hint = params[:sort]
    if @hint == 'title'
      @movies = Movie.find(:all, :order => 'title')
    else
      @movies = Movie.find(:all, :order => 'release_date')
    end

    
  end
  
  def new
    @movie = Movie.new
  end
  
  def create
    @movie = Movie.new(params[:movie])
    if @movie.save
      flash[:notice] = "#{@movie.title} added to Rotten Potatoes!"
      redirect_to movie_path(@movie)
    else
      render :action => "new"
    end
  end
  
  def show
    @movie = Movie.find(params[:id])
  end
  
  def edit
    @movie = Movie.find(params[:id])
  end
  
  def update
    @movie = Movie.find(params[:id])
    if @movie.update_attributes(params[:movie])
      flash[:notice] = "#{@movie.title} has been updated!"
      redirect_to movie_path(@movie)
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @movie = Movie.find(params[:id])
    if @movie.destroy
      flash[:notice] = "#{@movie.title} has been deleted!"
    else
      flash[:error] = "Failed to delete #{@movie.title}!"
    end
    redirect_to(movies_url)
  end

end

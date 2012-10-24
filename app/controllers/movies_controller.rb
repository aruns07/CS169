class MoviesController < ApplicationController

  def index

    if params[:ratings]
      @checkList = params[:ratings]
    else
      @checkList = {}
    end

    @hint = params[:sort]
    if @hint == 'title'
      @movies = Movie.find(:all, :conditions=>["rating in (?)" , @checkList.keys ] ,  :order => 'title')
    else
      @movies = Movie.find(:all, :conditions=>["rating in (?)" , @checkList.keys] ,  :order => 'release_date')
    end

    @all_ratings = ratingList

    
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

  def ratingList
    Movie.find(:all, :select=>"DISTINCT rating").map{ |m| m.rating}
  end

end

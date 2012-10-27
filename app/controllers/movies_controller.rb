class MoviesController < ApplicationController

  def index
    @all_ratings = ratingList
    @boolRating = false
    @boolSort = false
    @tempHash = Hash.new
   

    if params[:ratings]
      @checkList = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session.has_key?("ratings")
      @checkList = session[:ratings]
      @tempHash["ratings"] = @checkList
      @boolRating = true
    else
      @checkList = Hash.new
      ratingList.each{|a| @checkList[a]='true'}
      session[:ratings] = @checkList
    end

    if params[:sort]
      @hint = params[:sort]
      session[:sort] = @hint
    elsif session.has_key?("sort") 
      @hint = session[:sort]
      @tempHash["sort"] = @hint
      @boolSort = true
    else
      @hint = 'date'
      session[:sort] = @hint
    end
    

    if @boolRating ==true or @boolSort == true
      @temp = url_for(params.merge(@tempHash))
      session.delete("ratings")
      session.delete("sort")
      redirect_to ( @temp)
    end



    if @hint == 'title'
      @movies = Movie.find(:all, :conditions=>["rating in (?)" , @checkList.keys ] ,  :order => 'title')
    else
      @movies = Movie.find(:all, :conditions=>["rating in (?)" , @checkList.keys] ,  :order => 'release_date')
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

  def ratingList
    Movie.find(:all, :select=>"DISTINCT rating").map{ |m| m.rating}
  end

end

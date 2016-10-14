class SongsController < ApplicationController

  def index
    if params[:artist_id] #-- if artist foreign key is in url then try to find it in database
      @artist = Artist.find_by(id: params[:artist_id])

      if @artist.nil? # -- if there is no such artist in database return to the artists page
        flash[:alert]="Artist not found"
        redirect_to artists_path
      else
        @songs = @artist.songs # if artist is found then makr all songs of the particular artist avaiable to the artist songs index page
      end

    else
      @songs = Song.all # if none of the above is successful then make avaiable an array of all the songs in the database
    end
  end

  def show
    if params[:artist_id]
      @artist = Artist.find_by(id: params[:artist_id])
      @song = @artist.songs.find_by(id: params[:id])

      if @song.nil?
        flash[:alert]="Song not found"
        redirect_to artist_songs_path
      end

    else
      @song = Song.find(params[:id])
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else

      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

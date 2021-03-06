class PhotoStreamsController < ApplicationController
before_filter :authenticate_user!
before_filter :authorize_photo_stream_resource

  def authorize_photo_stream_resource
    begin
       authorize! :all, :photo_stream
    rescue CanCan::AccessDenied
      flash[:error] = "Photos is restricted to premium members. Become a premium member
          #{ActionController::Base.helpers.link_to "Register", edit_profile_path(current_user.permalink, :value => 'billing info')}".html_safe
        redirect_to(:back)
    end
  end

  def index
    @photo_streams =  current_user.profile.photo_streams
  end
  
  def create
    @photo_stream =  current_user.profile.photo_streams.build(params[:photo_stream])
    if @photo_stream.save!
      reset_session_activity
      redirect_to user_photo_stream_path(current_user.permalink, @photo_stream.id)
    else
      render :index
    end
     
  end
  def show
    photo_stream = PhotoStream.find(params[:id])
    if (current_user == photo_stream.profile.user) || current_user.can_view?(photo_stream.profile, 'PhotoStream')
      @photo_stream =  photo_stream
    else
      flash[:error] = 'Cannot access'
      redirect_to user_photo_streams_path(current_user.permalink)
    end 
  end

  def create_photo
    @photostream = current_user.profile.photo_streams.find(params[:photo_stream_id])
    @photo = @photostream.photos.build(:image => params[:upload][:image])
    if @photo.save!
       render :json => {:id => @photo.id, :pic_path => @photo.image.url.to_s, :name => @photo.image.url(:medium)}, :content_type => 'text/html'
    end
  end

  def update_photo
    if request.xhr?
      @photostream = current_user.profile.photo_streams.find(params[:photo_stream_id])
      photo = @photostream.photos.find(params[:id])
      photo.update_attributes(:title => params[:photo][:title])
      render :json => {:title => photo.title}
    end
  end
 
  def destroy_photo
    photo = Photo.find(params[:id])  
    if !photo.nil? && photo.photoable.profile.user == current_user
      photo.destroy
      flash[:success] = 'Successfully deleted'
    else
      flash[:error] = 'Cannot delete'
    end
    redirect_to user_photo_stream_path(current_user.permalink, photo.photoable)
  end

end 

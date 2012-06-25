class DiscussionsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @discussion = Discussion.new
    @discussions = Kaminari.paginate_array(Discussion.all(:include => :comments).reverse).page(params[:page]).per(3)
  end

  def new
  end

  def create
    params[:discussion][:question].strip!  unless params[:discussion][:question].nil?
    @discussion = Discussion.new(params[:discussion])
    @discussion.user_id = current_user
  
    respond_to do |format|
      if @discussion.save
         flash[:success]= "Discussion was successfully created."
       format.html { redirect_to discussions_path }
        format.json { head :ok }
      else
        flash[:error]= "Discussion was not created."
        format.html { render action: "index"}
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @discussion = Discussion.find(params[:id].to_i)
     
    params[:discussion][:comments]
    comments = params[:discussion][:comments]
    comments["user_id"] = current_user.id 
    @discussion.comments.build(comments)
    respond_to do |format|
      if @discussion.save
        flash[:success]= "Reply was successfully created."


       format.html { redirect_to discussions_path}
        format.json { head :ok }
      else
        flash[:error]= "Reply was not created."

        format.html { redirect_to discussions_path }
        format.json { render json: @discussion.errors, status: :unprocessable_entity }
      end
    end
  end
end
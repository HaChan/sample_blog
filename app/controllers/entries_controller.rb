class EntriesController < ApplicationController

  before_action :signed_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
  end

  def create
    @entry = current_user.entries.build(entry_params)
    if @entry.save
      flash[:success] = "Reply created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
		Entry.find(params[:id]).destroy
    flash[:success] = "User deleted."
#    redirect_to root_url
		redirect_to session[:return_to]
  end
  
  def new
    @entry = current_user.entries.new()
  end

  def edit
    @entry = current_user.entries.find(params[:id])
  end
  
	def update
	  if current_user?(@entry.user)
      @entry = current_user.entries.find(params[:id])
      if @entry.update_attributes(entry_params)
        # Handle a successful update.
        flash[:success] = "Entry updated"
        redirect_to root_url
      else
        render :edit
      end
    else
      render :edit
    end
  end
  
  def show
    @entry = Entry.find(params[:id])
    @comment_items = @entry.comments
  end

  private

    def entry_params
      params.require(:entry).permit(:title, :content)
    end

    def correct_user
      @entry = current_user.entries.find_by(id: params[:id])
      redirect_to root_url if @entry.nil?
    end
end

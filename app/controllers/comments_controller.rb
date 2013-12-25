class CommentsController < ApplicationController

  def create
    @comment = current_user.comments.build(comment_params)
#    @comment.entry_id = @entry.id
    @entry = Entry.find(@comment.entry_id)
#    @entry = @comment.entries
    @comment_items = @entry.comments
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @entry
    else
#			flash.now[:error] = @comment.errors[:content]
			@errors = @comment.errors
      render 'entries/show'
    end
  end
  
  private

    def comment_params
      params.require(:comment).permit(:entry_id, :content)
    end

end

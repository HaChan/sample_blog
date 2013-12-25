class DefaultPagesController < ApplicationController
  def home
    if signed_in?
      @entries  = current_user.entries.build
      
#      @feed_items = current_user.feed.paginate(page: params[:page])
			@feed_items = get_feed
#			@replies = get_reply
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end

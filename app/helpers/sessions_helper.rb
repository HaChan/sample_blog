module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token
		user.update_attribute(:remember_token, User.encrypt(remember_token))
		self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end


  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end

  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    self.current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
    self.current_user = nil
    cookies.delete(:remember_token)
		session.delete(:return_to)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end

	def signed_in_user
		store_location
#		session[:return_to] = request.url if request.get?
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
  
  
  def get_feed
		@feed_items ||= current_user.feed.paginate(page: params[:page], per_page: 3)
	end
	
	def get_reply
#	  query = "Select * From microposts Where reply_post <> null "
	  @replies ||= current_user.feed.where('reply_post is not null')
	end
	
end

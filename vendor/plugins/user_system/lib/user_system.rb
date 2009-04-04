module UserSystem
  class AccessDenied < RuntimeError
    def message
      'You are not authorized to do this.'
    end
    
    def status_code
      403
    end
  end
  
  class LoginRequired < RuntimeError
    def message
      'Login is required.'
    end
    
    def status_code
      401
    end
  end
  
  def self.included(base)
    base.helper_method :current_user, :logged_in?
  end
  
  def self.current_user
    ApplicationController.get_controller.current_user
  end
  
  def self.logged_in?
    ApplicationController.get_controller.logged_in?
  end
  
  def current_user
    unless logged_in?
      @current_user ||= Guest.new(session)
    end
    @current_user
  end

  # Sets the current user. This value can be retrieved using UserSystem#current_user.
  def current_user=(user)
    session[:user] = (user.class == User) ? user.id : nil
    @current_user = (user.class == User) ? user : nil
  end
  
    # Return true if the client is logged in and false if not.
  def logged_in?
    if @current_user.is_a?(User)
      # Check that the session user is still the same user as the one we have cached
      @current_user = false unless @current_user.id == session[:user]
    else
      # if there is no one logged in, try to log in a user from session
      @current_user ||= session[:user] ? User.find_by_id(session[:user]) : false
    end             
    @current_user.is_a?(User)
  end

  # Used as a simple before filter to block parts of website that only registered users have access to.
  # For specific priviledges see UserSystem#must_belong_to and UserSystem#must_belong_to_one_of.
  def login_required
    raise LoginRequired unless logged_in?
    true
  end
  
  def must_be_admin
    raise AccessDenied unless current_user.admin?
    return true
  end
  
  class Guest
    def initialize(session)
      @session = session
      unless(session[:guest_id].to_i != 0 and @user = User.find_by_id(session[:guest_id]))
        @user = User.new :login => nil, :email => nil, :guest => true
        @user.save_with_validation(false)
        session[:guest_id] = @user.id
      end
    end
    
    def id
      @user.id
    end
    
    def basket
      @user.basket
    end
    
    def pagination_setting
      30
    end
    
    def interface_language
      @session[:interface_language] ? @session[:interface_language] : Configuration.default_language
    end
    
    def interface_language=(lang)
      @session[:interface_language] = lang
    end
    
    def login
      I18n.translate 'not_logged_in', :scope => [:user_system]
    end
    
    def guest?
      true
    end
    
    def admin?
      false
    end
    
    def method_missing(method, *args)
      @user.send method, *args
      #keep your mouth shut
    end
    
    def self.method_missing(method, *args)
      User.send method, *args
    end
  end
end
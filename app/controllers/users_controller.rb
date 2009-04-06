class UsersController < ApplicationController
  before_filter :load_user, :except => [:new]
  def new
    @user ||= User.new
  end
  
  def login
    if(self.current_user = User.authenticate(params['user']['login'], params['user']['password']))
      respond_to do |format|
        format.html do
          flash[:notice] = t :login_ok
          redirect_to :back
        end
        format.js do
          flash[:notice] = t :login_ok
          render :update do |page|
            page << 'window.location.reload();'
          end
        end
        format.xml do
          head :ok
        end
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = t :bad_login
          redirect_to :back
        end
        format.js do
          render :update do |page|
            page.visual_effect :shake, 'user_box'
            page.replace_html "notice", t(:bad_login)
          end
        end
        format.xml do
          head :unauthorized
        end
      end
    end
  end
  
  def logout
    reset_session
    respond_to do |format|
      format.html do
        flash[:notice] = t :logged_out
        redirect_to "/"
      end
      format.js do
        render :update do |page|
          flash.now[:notice] = t :logged_out
          page << 'window.location = "/";'
        end
      end
      format.xml do
        head :ok
      end
    end
  end
  
  def create
    @user = User.new(params[:user])
    if @user.valid? and @user.save
      self.current_user = @user
      render
    else
      render "new"
    end
  end 
  
  def edit
    if current_user.guest?
      redirect_to :action => :new
    else
      @user = current_user
      render
    end
  end
  
  protected
  def load_user
    @user = (current_user.admin?)? ((params[:id])? User.find(params[:id]) : current_user) : current_user 
  end
  
end

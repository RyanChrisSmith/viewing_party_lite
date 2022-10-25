class UsersController < ApplicationController
  def show
    @user = User.find(session[:user_id])
    @parties = @user.parties
    # #@hosted_parties = @user.parties.where(host_status: true)
  end

  def discover
    @user = User.find(session[:user_id])
  end

  def new; end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      redirect_to users_path
      flash[:notice] = "Welcome #{user.name}"
    else
      redirect_to('/register')
      flash[:failure] = user.errors.full_messages.first
    end
  end

  def login_form; end

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to users_path
      flash[:success] = "Welcome back, #{user.email}!"
    else
      redirect_to '/login'
      flash[:error] = 'Invalid Credentials'
    end
  end

  def logout
    session.destroy
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end
end

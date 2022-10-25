class PartiesController < ApplicationController
  before_action :require_user, only: [:new, :create]

  def new
    @user = User.find(session[:user_id])
    @users = User.where.not(id: params[:user_id])
    @movie = MoviesFacade.movie_details(params[:movie_id])
  end

  def create
    @user = User.find(session[:user_id])
    @party = Party.new(party_params)
    if @party.save
      @user_party = UserParty.create!(user_id: @user.id, party_id: @party.id, host_status: true)
      redirect_to users_path
      if params[:invitees] != [""]
        params[:invitees].each do |user_id|
          UserParty.create!(user_id: user_id.to_i, party_id: @party.id, host_status: false) if user_id != ""
        end
      end
    else
      redirect_to new_users_movie_party_path(params[:movie_id])
      flash[:alert] = 'Please Input a Valid Day and Time'
    end
  end

  private

  def party_params
    params.permit(:duration, :start_time, :date, :movie_id)
  end
end

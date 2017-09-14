class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end

  def show
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end

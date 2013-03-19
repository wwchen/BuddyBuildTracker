class UsersController < ApplicationController
  def index
    @users = User.all

    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    @user = User.find_by_alias("#{params[:id]}") || not_found
    #@user = User.find(params[:id]) || User.find_by_alias(params[:alias]) || not_found
  end

  def edit
    @user = User.find_by_alias(params[:id]) || not_found
    #@user = User.find(params[:id]) || User.find_by_alias(params[:alias]) || not_found
  end

  def update
    @user = User.find_by_alias(params[:id]) || not_found
    #@user = User.find(params[:id]) || User.find_by_alias(params[:alias]) || not_found

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'user was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def not_found
    #raise ActionController::RoutingError.new('Not Found')
  end
end

class BugsController < ApplicationController
  def index
    @bugs = Bug.all

    respond_to do |format|
      format.html
      format.json { render json: @bugs }
    end
  end
end

class EmailsController < ApplicationController
  def index
    @emails = Email.all

    respond_to do |format|
      format.html
      format.json { render json: @emails }
    end
  end
end

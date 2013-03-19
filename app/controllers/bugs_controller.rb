class BugsController < ApplicationController
  def index
    @bugs = Bug.all

    respond_to do |format|
      format.html
      format.json { render json: @bugs }
    end
  end

  def show
    @bug = Bug.find_by_tfs_id(params[:id])
  end

  def edit
    @bug = Bug.find_by_tfs_id(params[:id])
  end

  def update
    @bug = Bug.find_by_tfs_id(params[:id])

    respond_to do |format|
      if @bug.update_attributes(params[:bug])
        format.html { redirect_to @bug, notice: 'bug was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bug.errors, status: :unprocessable_entity }
      end
    end
  end
end

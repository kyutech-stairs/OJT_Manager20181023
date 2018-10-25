# frozen_string_literal: true

class ChecklistsController < ApplicationController
  def index
    @checklist = Checklist.all
  end

  def new
    @checklist = Checklist.new
    @new_num = Checklist.count + 1
    #temp = Checklist.where(sirabasu_id: params[:sirabasu_id])
  end

  def create
    @sirabasu = Sirabasu.find_by(number: params[:sirabasu_id])
    @checklist = @sirabasu.checklists.new(checklist_params)
    
    if @checklist.save
      redirect_to sirabasu_path(@sirabasu.number)
    else
      render 'new'
    end
  end

  def edit
    @checklist = Checklist.find(params[:id])
  end

  def update
    @checklist = Checklist.find(params[:id])
    @checklist.update(checklist_params)
    redirect_to sirabasu_checklist_path
  end

  def destroy
    @checklist = Checklist.find(params[:id])
    @checklist.destroy
    @checklist = Checklist.all
    i = 1
    @checklist.each do |che|
      che.number = i
      che.save
      i += 1
    end
    redirect_to sirabasus_checklist_path
  end

  def checklist_params
    params.require(:checklist).permit(:number, :name, :content)
  end
end

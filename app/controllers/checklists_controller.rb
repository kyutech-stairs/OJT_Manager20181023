# frozen_string_literal: true

class ChecklistsController < ApplicationController
  # def index
  #   @checklist = Checklist.all
  # end

  def new
    @checklist = Checklist.new
    #@new_num = Checklist.count + 1
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id],cid: current_kanrisya.cid)
    @chapter = sirabasu.number
    @new_num = sirabasu.checklists.count + 1
  end

  def create
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id],cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.new(checklist_params)
    #@new_num = Checklist.count + 1
    @new_num = sirabasu.checklists.count + 1
    if @checklist.save
      redirect_to sirabasu_path(sirabasu.number)
    else
      render "new"
    end
  end

  def edit
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id],cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.find_by(number: params[:id])
  end

  def update
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id],cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.find_by(params[:id])
    if @checklist.update(checklist_params)
    redirect_to sirabasu_path(sirabasu.number)
    else
      render "edit"
    end
  end

  def destroy
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id],cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.find_by(number: params[:id])
    @checklist.destroy
    @checklist = sirabasu.checklists
    i = 1
    @checklist.each do |che|
      che.number = i
      che.save
      i += 1
    end
    redirect_to sirabasu_path(sirabasu.number)
  end

  def checklist_params
    params.require(:checklist).permit(:number, :content)
  end
end

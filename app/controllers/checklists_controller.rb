# frozen_string_literal: true

class ChecklistsController < ApplicationController
  def checkuser
   @sirabasu = Sirabasu.find(params[:sirabasu_id])
   @checklist = @sirabasu.checklists.all
   @kanrisya = Kanrisya.find(params[:kanrisya_id])
   @checkuser = []
   @checklist.each do |checklist|
    @checkuser[checklist.number] = Checkuser.find_by(checklist_id: checklist.id,kanrisya_id: @kanrisya.id)
   end
  end

  def new
    if current_kanrisya.admin == true
      @checklist = Checklist.new
      # @new_num = Checklist.count + 1
      sirabasu = Sirabasu.find_by(number: params[:sirabasu_id], cid: current_kanrisya.cid)
      @chapter = sirabasu.number
      @new_num = sirabasu.checklists.count + 1
    else
      redirect_to '/user/not'
    end
  end

  def create
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id], cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.new(checklist_params)
    # @new_num = Checklist.count + 1
    @new_num = sirabasu.checklists.count + 1
    if @checklist.save
      #中間テーブルへの保存開始
      kanrisya = Kanrisya.where(cid: @checklist.cid).where(admin: false)
      kanrisya.each do |i|
      @checkuser = Checkuser.new(
        kanrisya_id: i.id,
        checklist_id: @checklist.id
      )
      @checkuser.save
      end
      #中間テーブルへの保存ここまで
      redirect_to sirabasu_path(sirabasu.number)
    else
      render 'new'
    end
  end

  def edit
    if current_kanrisya.admin == true
      sirabasu = Sirabasu.find_by(number: params[:sirabasu_id], cid: current_kanrisya.cid)
      @checklist = sirabasu.checklists.find_by(number: params[:id])
    else
      redirect_to '/user/not'
   end
  end

  def update
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id], cid: current_kanrisya.cid)
    @checklist = sirabasu.checklists.find_by(params[:id])
    if @checklist.update(checklist_params)
      redirect_to sirabasu_path(sirabasu.number)
    else
      render 'edit'
    end
  end

  def destroy
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id], cid: current_kanrisya.cid)
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
    params.require(:checklist).permit(:number, :content, :cid, :userid)
  end
end

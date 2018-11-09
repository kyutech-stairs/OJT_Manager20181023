class CheckusersController < ApplicationController
  def index
    @checklist = Checklist.all
  end

  def new
    @sirabasu = Sirabasu.find(number: params[:id])
    @checklist = @sirabasu.checklists.all
  end

  def create
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id])
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
    @sirabasu = Sirabasu.find_by(number: params[:id])
    @checklist = @sirabasu.checklists.all
  end

  def update
    #sirabasu = Sirabasu.find_by(number: params[:sirabasu_id])
    #@checklist = sirabasu.checklists.find_by(params[:id])
    #if @checklist.update(checklist_params)
    redirect_to "/sirabasus"
    #else
    #  render "edit"
    #end
  end

  def destroy
    sirabasu = Sirabasu.find_by(number: params[:sirabasu_id])
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

  def checkup
    @dekita = Checkuser.where("checklist_id in (?)", params[:check_id]).where(kanrisya_id: current_kanrisya.id)
    @checkuser = Checkuser.where("checklist_id in (?)", params[:checklist_id]).where(kanrisya_id: current_kanrisya.id)
    @checkuser.update(check_ok: false)
    @checkuser.each do |c|
      @dekita.each do |d|
      if c.id == d.id
       c.update(check_ok: true)
      end
    end
    end
    redirect_to sirabasu_path(params[:AAAA])
  end

  def checklist_params
    params.require(:checklist).permit(:number, :content, :cid, :userid)
  end
  #def checkuser_params
    #params.require(:checklist_id).permit(id: [])
  #end
end

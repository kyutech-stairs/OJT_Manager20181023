class CheckusersController < ApplicationController
  def checkup
    @dekita = Checkuser.where("checklist_id in (?)", params[:check_id]).where(kanrisya_id: current_kanrisya.id)
    @checkuser = Checkuser.where("checklist_id in (?)", params[:checklist_id]).where(kanrisya_id: current_kanrisya.id)
    user = Kanrisya.find(current_kanrisya.id)
    @checkuser.update(check_ok: false)
    @checkuser.each do |c|
      @dekita.each do |d|
      if c.id == d.id
       if c.update(check_ok: true)
         user.update(check_time: Time.now)
       end
      end
    end
    end
    redirect_to sirabasu_path(params[:AAAA])
  end

  def del
    @sirabasu = Sirabasu.find(params[:id])
    redirect_to "/sirabasus"
  end

  def checklist_params
    params.require(:checklist).permit(:number, :content, :cid, :userid)
  end
  #def checkuser_params
    #params.require(:checklist_id).permit(id: [])
  #end
end

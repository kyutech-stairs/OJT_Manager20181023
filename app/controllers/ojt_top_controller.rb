class OjtTopController < ApplicationController

  def kanri
  end

  def user
  end
  def top
    @checkuser = Kanrisya.limit(6).order("check_time DESC") # updated_timeの降順で60件取得
    @user = []
    @user_sign = []
    @check_parcent = []
    @checkuser.each do |checkuser|
        @user[checkuser.id] = Kanrisya.find(checkuser.id)
        check = Checkuser.where(kanrisya_id: @user[checkuser.id].id).where(check_ok: true)
        check_all = Checkuser.where(kanrisya_id: @user[checkuser.id].id)
        sirabasu = Sirabasu.where(cid: @user[checkuser.id].cid)
        sirabasu.each do |s|
         s_check = s.checklists.all
         sirabasuuser = Sirabasuuser.where(sirabasu_id: s.id).where(kanrisya_id: @user[checkuser.id].id)
         sirabasuuser.each do |sirabasuuser|
         if sirabasuuser.sirabasu_ok == false
         @s_check_ok = 0
          s_check.each do |s_check|
           s_check_ok = Checkuser.where(kanrisya_id: @user[checkuser.id].id).where(checklist_id: s_check.id).where(check_ok: true)
           @s_check_ok = @s_check_ok + s_check_ok.count
          end
          i = @s_check_ok/s_check.count rescue 0
          if i == 1
           @user_sign[checkuser.id] = true
          end
          end
         end
        end
        sirabasuuser = @user[checkuser.id].sirabasuusers.all
        @check_parcent[checkuser.id] = ((check.count/(check_all.count).to_f).round(2)*100).to_i rescue 0
    end
  end

end

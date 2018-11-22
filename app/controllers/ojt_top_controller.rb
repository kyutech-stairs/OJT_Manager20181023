class OjtTopController < ApplicationController

  def kanri
  end

  def user
  end

  def copy_check
    @company = Company.find_by(id: params[:id])
  end

  def copy
    @copy_from = Company.find(params[:id])
    if params[:pas] == "#{@copy_from.pas}"
     sirabasu_from = Sirabasu.where(cid: @copy_from.cid)
     sirabasu_from.each do |sirabasu_from|
       sirabasu = Sirabasu.new(
         name: sirabasu_from.name,
         content: sirabasu_from.content,
         number: sirabasu_from.number,
         userid: current_kanrisya.id,
         image: sirabasu_from.image,
         cid: current_kanrisya.cid
       )
       if sirabasu.save
         checklist_from = sirabasu_from.checklists.all
         #シラバス中間テーブルへの保存開始
         kanrisya = Kanrisya.where(cid: @copy_from.cid).where(admin: false)
         kanrisya.each do |i|
         @sirabasuuser = Sirabasuuser.new(
           kanrisya_id: i.id,
           sirabasu_id: sirabasu_from.id
         )
         @sirabasuuser.save
         end
         #中間テーブルへの保存ここまで
         sirabasu_from
       end
     end
     redirect_to "/sirabasus"
    else
      redirect_to ojt_top_copy_check_path(id: @copy_from.id)
    end
  end

  def top
    if current_kanrisya.admin == true
      @company = Company.find_by(cid: current_kanrisya.cid)
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
    else
      @sirabasu = []
      @updated = []
      @checkuser = []
      # 各シラバスで、最新のチェックリスト更新をひとつ取得する
      @checkuser = current_kanrisya.checkusers.order(updated_at: :DESC)
      # 最近更新したチェックリストを降順に取得
      @checkuser.each do |che|
        s = Sirabasu.find(che.checklist.sirabasu_id)
        insert_ok = true
        # そのシラバスは取組中（0%でなく、100%でもない）ですか？
        if is_this_sirabasu_doing(s)
          # 重複を避ける
          @sirabasu.each do |sira|
            if sira.id == s.id
              insert_ok = false
            end
          end
          if insert_ok
            @updated[s.id] = che.updated_at
            @sirabasu.push(s)
          end
        end
      end
    end
  end

  def is_this_sirabasu_doing(sirabasu)
    per_0 = true
    per_100 = true
    sirabasu.checklists.each do |c|
      if current_kanrisya.checkusers.find_by(checklist_id: c.id).check_ok
        # 1つでもチェックされていたら0%ではない
        per_0 = false
      else
        # 1つでもチェックされていなかったら100%ではない
        per_100 = false
      end
    end
    return !(per_0 || per_100)
  end
end

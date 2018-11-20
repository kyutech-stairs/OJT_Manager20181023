class OjtTopController < ApplicationController

  def kanri
  end

  def user
  end
  def top
    @checkuser = Kanrisya.limit(6).order("check_time DESC") # updated_timeの降順で60件取得
    @user = []
    @check_parcent = []
    @checkuser.each do |checkuser|
        @user[checkuser.id] = Kanrisya.find(checkuser.id)
        check = Checkuser.where(kanrisya_id: @user[checkuser.id].id).where(check_ok: true)
        check_all = Checkuser.where(kanrisya_id: @user[checkuser.id].id)
        @check_parcent[checkuser.id] = ((check.count/(check_all.count).to_f).round(2)*100).to_i rescue 0
    end
  end

end

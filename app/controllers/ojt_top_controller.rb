class OjtTopController < ApplicationController

  def kanri
  end

  def user
  end
  def top
    @checkuser = Kanrisya.limit(6).order("check_time DESC") # updated_timeの降順で60件取得
    @user = []
    @checkuser.each do |checkuser|
        @user[checkuser.id] = Kanrisya.find(checkuser.id)
    end
  end

end

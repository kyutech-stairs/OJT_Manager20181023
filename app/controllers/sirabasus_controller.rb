# frozen_string_literal: true

class SirabasusController < ApplicationController
  def index
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    if current_kanrisya.admin == false
      # @stat: 各シラバスが利用できるかを配列で
      @stat_list = []
      @sirabasu.each do |s|
        if is_this_sirabasu_available(s)
          if is_this_sirabasu_done(s)
            @stat_list.push("完了")
          else
            # 進捗を取得
            tmp = get_percent(s)
            @stat_list.push("#{tmp.fetch(2)}% ")
          end
        else
          @stat_list.push("利用不可")
        end
      end
    end
  end

  def show
    @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @images = @sirabasu.images.all
    #シラバスを作った管理者が見つかる
    @kanrisya = Kanrisya.find(@sirabasu.userid)
    # 今選択しているシラバスに紐付くチェックリストを抽出
    @checklist = @sirabasu.checklists.all
    #前提シラバスがクリアできていたらtrue（管理者の場合は無関係）
    @stat = true
    # 従業員か管理者かで以下の処理
    if current_kanrisya.admin == false
      # 従業員なら
      # 前提シラバスがクリアできていたらtrue
      @stat = is_this_sirabasu_available(@sirabasu)
      # 今ログインしている従業員に紐づくレコードを抽出
      @checkuser = Kanrisya.find(current_kanrisya.id).checkusers.all
      # 前提シラバスを取得
      @p_c = @sirabasu.publishing_configs.all
      @zentei = []
      @stat_list = []
      unless @p_c.empty?
        @p_c.each do |p|
          s = Sirabasu.find_by(id: p.required_sirabasu, cid: current_kanrisya.cid)
          @zentei.push(s)
          if is_this_sirabasu_available(s)
            if is_this_sirabasu_done(s)
              @stat_list.push("完了")
            else
              # 進捗を取得
              tmp = get_percent(s)
              @stat_list.push("#{tmp.fetch(2)}% " + "(#{tmp.fetch(0)}/" + "#{tmp.fetch(1)})")
            end
          else
            @stat_list.push("利用不可")
          end
        end
      end
    else
      # 管理者なら
      @checklist = @sirabasu.checklists.all
    end
  end

  def new
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.new
      # @sirabasu.images.build
      @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1
      @checklist_num = 1
    else
      redirect_to '/user/not'
    end
  end

  def create
    @sirabasu = Sirabasu.new(sirabasu_params)
    @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1
    @checklist_num = 1
    if @sirabasu.save
      #シラバス中間テーブルへの保存開始
      kanrisya = Kanrisya.where(cid: @sirabasu.cid).where(admin: false)
      kanrisya.each do |i|
      @sirabasuuser = Sirabasuuser.new(
        kanrisya_id: i.id,
        sirabasu_id: @sirabasu.id
      )
      @sirabasuuser.save
      end
      #中間テーブルへの保存ここまで
      redirect_to sirabasus_path
    else
      render 'new'
    end
  end

  def edit
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
      # @sirabasu.checklists.build
      @checklist_num = 1
    else
      redirect_to '/user/not'
   end
  end

  def update
    @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @checklist_num = 1
    # シラバスの更新、チェックリストの作成・更新
    if @sirabasu.update(sirabasu_params)
      num = 1
      # numberカラムの振り分け
      @sirabasu.checklists.each do |che|
        che.update_attributes(number: num)
        # 管理者でなく、cidの一致するユーザすべて
        kanrisya = Kanrisya.where(cid: che.cid).where(admin: false)

        kanrisya.each do |i|
          # レコードの重複を避ける
          next if Checkuser.find_by(checklist_id: che.id, kanrisya_id: i.id)
          che.checkusers.create(
            kanrisya_id: i.id
          )
        end
        num += 1
      end
      redirect_to action: 'index'
    else
      render 'edit'
    end
  end

  # データを削除するためのAction
  def destroy
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
      # 公開設定から、消しきれないレコードを殲滅
      PublishingConfig.where(required_sirabasu: @sirabasu.id).destroy_all
      @sirabasu.destroy
      @sirabasu = Sirabasu.where(cid: current_kanrisya.cid)
      i = 1
      @sirabasu.each do |sira|
        sira.number = i
        sira.save
        i += 1
      end
      redirect_to sirabasus_path
    else
      redirect_to '/user/not'
    end
  end

  def sirabasu_complete
   @sirabasuuser = Sirabasuuser.find(params[:id])
   @sirabasuuser.update(sirabasu_ok: true)
   redirect_to user_path(params[:BBBB])
  end

  def publishing_config
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    @now = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @num = @now.number
    # @conf = @now.publishing_configs.all
    @conf = []
    @sirabasu.each do |sirabasu|
      @conf[sirabasu.id] = sirabasu.publishing_configs.all
    end
  end

  def publishing_config_update
    @now = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @now_c = @now.publishing_configs.all
    # unless @now_c.empty?
      @now_c.destroy_all
    # end
    params[:sirabasu_id].each do |p|
      unless p.empty?
        @now.publishing_configs.create(required_sirabasu: p)
      end
    end
    flash[:config_update] = "公開設定を更新しました"
    redirect_to publishing_config_path(params[:id])
    # redirect_to '/sirabasus'
  end

  def sirabasu_params
    params.require(:sirabasu).permit(:number, :name, :content, :userid, :cid, {image: []},
    images_attributes: [:image_path],
    checklists_attributes: [:id, :sirabasu_id, :number, :content, :userid, :cid, :_destroy])
  end

  def user_params
    params.require(:kanrisya).permit(:id, :name, :cid, check: [])
  end

  # 現在ログイン中の従業員がそのシラバスの前提を完遂しているか判断
  def is_this_sirabasu_available(sirabasu)
    # stat:そのシラバスを表示してもよいか(boolean)
    stat = true
    # p_c:siraに対するpublishing_configの全レコード
    p_c = sirabasu.publishing_configs.all
    # siraについて何も設定されていないなら常に表示とみなす
    unless p_c.empty?
      # 各レコードを見て、
      p_c.each do |p|
        # required_sirabasuから、シラバスを取り出す
        s = Sirabasu.find_by(cid: current_kanrisya.cid, id: p.required_sirabasu)
        # そのシラバスが完了していないなら
        unless is_this_sirabasu_done(s)
          # puts s.id
          # puts "のシラバスは完了していません"
          # 1回でもここに来ると、表示されない
          stat = false
        end
      end
    end
    return stat
  end

  # そのシラバスの完了は管理者に承認されましたか？
  def is_this_sirabasu_done(sirabasu)
    return current_kanrisya.sirabasuusers.find_by(sirabasu_id: sirabasu.id).sirabasu_ok
    # che = sirabasu.checklists.all
    # che.each do |c|
    #   unless current_kanrisya.checkusers.find_by(checklist_id: c.id).check_ok
    #   # unless Checkuser.find_by(kanrisya_id: current_kanrisya.id,checklist_id: c.id).check_ok
    #     return false
    #   end
    # end
    # return true
  end

  # シラバスの進捗を％で取得
  def get_percent(sirabasu)
    checklist = sirabasu.checklists.all
    checklist_count = checklist.count
    checked_count = 0
    checklist.each do |c|
      if current_kanrisya.checkusers.find_by(checklist_id: c.id).check_ok
        checked_count += 1
      end
    end
    per = ((checked_count / (checklist_count).to_f).round(2) * 100).to_i rescue 0
    # [チェックされた個数, チェックリストの総数, 割合]で返却
    return [checked_count, checklist_count, per]
  end
end

# frozen_string_literal: true

class SirabasusController < ApplicationController
  def index
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    else
      @sirabasu = []
      stat = true
      Sirabasu.where(cid: current_kanrisya.cid).order(:number).each do |s|
        # 1つめはかならず表示
        if s.number == 1 || stat
          @sirabasu.push(s)
        end
        stat = is_this_sirabasu_done(s) # これがtrueなら、次のシラバスを表示
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
    # 今ログインしている従業員に紐づくレコードを抽出
    @checkuser = Kanrisya.find(current_kanrisya.id).checkusers.all
  end

  def new
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.new
      # @sirabasu.images.build
      @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1

    else
      redirect_to '/user/not'
    end
  end

  def create
    @sirabasu = Sirabasu.new(sirabasu_params)
    @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1
    if @sirabasu.save
      redirect_to('/sirabasus')
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

  # データを更新するためのAction
  def update
    # ここちょっとよくわからないですね（by 吉井）
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

  def publishing_config
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    @now = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @num = @now.number
    @conf = @now.publishing_configs.all
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
    redirect_to '/sirabasus'
  end

  def sirabasu_params
    params.require(:sirabasu).permit(:number, :name, :content, :userid, :cid, 
    images_attributes: [:image_path], 
    checklists_attributes: [:id, :sirabasu_id, :number, :content, :userid, :cid, :_destroy])
  end

  def user_params
    params.require(:kanrisya).permit(:id, :name, :cid, check: [])
  end

  # そのシラバスは進捗100%ですか？
  def is_this_sirabasu_done(sirabasu)
    che = sirabasu.checklists.all
    che.each do |c|
      unless current_kanrisya.checkusers.find_by(checklist_id: c.id).check_ok
      # unless Checkuser.find_by(kanrisya_id: current_kanrisya.id,checklist_id: c.id).check_ok
        return false
      end
    end
    return true
  end
end

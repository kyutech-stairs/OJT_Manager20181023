# frozen_string_literal: true

class SirabasusController < ApplicationController
  def index
<<<<<<< HEAD
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    else
      @sirabasu = []
      sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
      
      # 各シラバスに対して、前提シラバスが全て完了しているか？
      sirabasu.each do |sira|
        if is_this_sirabasu_available(sira)
          @sirabasu.push(sira)
        end
      end
    end
=======
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    # @checklist = Checklist.all.order(:number)
>>>>>>> 178d251a5e8ecb894cc16d1b1cf89f1442f1673d
  end

  def show
    @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
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
        #中間テーブルへの保存開始
        kanrisya = Kanrisya.where(cid: @sirabasu.cid).where(admin: false)
        kanrisya.each do |i|
        @sirabasuuser = Sirabasuuser.new(
          kanrisya_id: i.id,
          sirabasu_id: @sirabasu.id
        )
        @sirabasuuser.save
        #中間テーブルへの保存ここまで
        end
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

  def sirabasu_complete
    @sirabasuuser = Sirabasuuser.find(params[:id])
    @sirabasuuser.update(sirabasu_ok: true)
    redirect_to user_path(params[:BBBB])
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
    params.require(:sirabasu).permit(:number, :name, :content, :userid, :cid, {image: []}, images_attributes: [:image_path], checklists_attributes: [:id, :sirabasu_id, :number, :content, :userid, :cid, :_destroy])
  end

  def user_params
    params.require(:kanrisya).permit(:id, :name, :cid, check: [])
  end
end

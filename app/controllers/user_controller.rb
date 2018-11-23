class UserController < ApplicationController

  def index
    @user = Kanrisya.where(name: params[:name]).where(cid: current_kanrisya.cid)
    @i = 0

    if params[:sirabasu] != "" && params[:ok] != "" then
     @sirabasuuser = Sirabasuuser.where(sirabasu_id: params[:sirabasu]).where(sirabasu_ok: params[:ok])
     @user2 = []
     @sirabasuuser.each do |sirabasuuser|
      if params[:sex] == "" && params[:belong] == "" then
       @user2[@i] = Kanrisya.find_by(id: sirabasuuser.kanrisya_id)
       @i = @i + 1
      elsif params[:sex] != "" && params[:belong] == "" then
        u = Kanrisya.find_by(id: sirabasuuser.kanrisya_id)
        if u.sex == params[:sex]
          @user2[@i] = Kanrisya.find_by(id: u.id)
          @i = @i + 1
        end
      elsif params[:sex] == "" && params[:belong] != "" then
        u = Kanrisya.find_by(id: sirabasuuser.kanrisya_id)
        if u.belong == params[:belong]
          @user2[@i] = Kanrisya.find_by(id: u.id)
          @i = @i + 1
        end
      elsif params[:sex] != "" && params[:belong] != "" then
        u = Kanrisya.find_by(id: sirabasuuser.kanrisya_id)
        if u.belong == params[:belong] && u.sex == params[:sex]
          @user2[@i] = Kanrisya.find_by(id: u.id)
          @i = @i + 1
        end
       end
     end

    elsif params[:sex] != "" then
      if params[:belong] != ""
       @user = Kanrisya.where(sex: params[:sex]).where(belong: params[:belong]).where(cid: current_kanrisya.cid)
      else
        @user = Kanrisya.where(sex: params[:sex]).where(cid: current_kanrisya.cid)
      end

    elsif params[:belong] != "" then
      @user = Kanrisya.where(belong: params[:belong]).where(cid: current_kanrisya.cid)
    end

    @kanrisya = Kanrisya.all
    @checkuser = Checkuser.all
  end

  def show
     @kanrisya = Kanrisya.find(params[:id])
   if @kanrisya.admin == false
    #そのユーザーに関連するチェック判定全て
    @checkuser = Checkuser.where(kanrisya_id: params[:id])
    #そのユーザーがチェックしたもの全て
    @checkuser_ok = Checkuser.where(kanrisya_id: params[:id]).where(check_ok: true)
    #チェックした総数
    @check_ok_count = @checkuser_ok.count
    #そのユーザーに関係あるチェッく数
    @check_count = @checkuser.count
    #全チェックの進捗%
    @check_parcent = ((@check_ok_count/@check_count.to_f).round(2)*100).to_i rescue 0
    #ユーザーに関連するシラバスの情報
    @sirabasu = Sirabasu.where(cid: @kanrisya.cid)
    i = 0
    #各シラバスの進捗
    @sirabasu_check_ok_parcent = []
    # 各シラバスでチェックした数
    @sirabasu_check_ok = []
    # 各シラバスのチェックリストの数
    @sirabasu_check_count = []
    while i < @sirabasu.count do
      #シラバスに関係するチェックリストの取得
      @sirabasu_check = @sirabasu[i].checklists.all
      #チェックリストに関連するチェック判定の取得
      @sirabasu_check_ok[i] = 0
      # 各チェックリストについて調べる
      @sirabasu_check.each do |sirabasu_check|
        sirabasu_check_ok = Checkuser.where(checklist_id: sirabasu_check.id).where(kanrisya_id: @kanrisya.id).where(check_ok: true)
        @sirabasu_check_ok[i] += sirabasu_check_ok.count
      end
      @sirabasu_check_count[i] = @sirabasu_check.count
      @sirabasu_check_ok_parcent[i] = ((@sirabasu_check_ok[i]/(@sirabasu_check_count[i]).to_f).round(2)*100).to_i rescue 0
      if @sirabasu_check_ok_parcent[i] != 100
        sirabasuuser = Sirabasuuser.where(kanrisya_id: @kanrisya.id).where(sirabasu_id: @sirabasu[i].id)
        sirabasuuser.update(sirabasu_ok: false)
      end
      i = i + 1
    end
    @sirabasuuser = []
    @sirabasu.each do |sirabasu|
    @sirabasuuser[sirabasu.id] = Sirabasuuser.find_by(kanrisya_id: @kanrisya.id, sirabasu_id: sirabasu.id)
    end
   end
  end

  def search
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid)
    @sirabasu_choise = []
    @sirabasu_choise << ["",""]
    @sirabasu.each do |sirabasu|
     @sirabasu_choise << [sirabasu.name,sirabasu.id]
    end
  end

  def company_save
    @copy_from = Company.find_by(cname: params[:cname], copy: true)
    @company = Company.new(cname: params[:cname],cid: params[:cid], cname_sub: params[:cname_sub])
    if @company.save
      if @copy_from.present?
        redirect_to ojt_top_copy_check_path(id: @copy_from.id)
      else
        redirect_to "/ojt_top/top"
      end
    else
      logger.debug @company.errors.inspect
      redirect_to "/user/hei"
    end
  end

  def company_up
    @company = Company.find(params[:id])
    if @company.update(cname: params[:cname],cid: params[:cid], cname_sub: params[:cname_sub], password: params[:password], copy: params[:copy])
      redirect_to "/ojt_top/top"
    else
      logger.debug @company.errors.inspect
      redirect_to "/user/hei2"
    end
  end

  def hei
  end

  def hei2
    @company = Company.find_by(cid: current_kanrisya.cid)
  end

  def new
    if current_kanrisya.admin == true
     @kanrisya = Kanrisya.new
    # @checkuser = Checkuser.new
    else
      redirect_to "/user/not"
    end
  end

  def create
    @kanrisya = Kanrisya.new(kanrisya_params)
    if @kanrisya.save
      flash[:success] = '新しいユーザーを登録しました。'
      #中間テーブルへの保存開始
      checklist = Checklist.where(cid: @kanrisya.cid)
      checklist.each do |i|
      @checkuser = Checkuser.new(
        kanrisya_id: @kanrisya.id,
        checklist_id: i.id
      )
      @checkuser.save
      end
      #中間テーブルへの保存ここまで
      #シラバス中間テーブルへの保存開始
      sirabasu = Sirabasu.where(cid: @kanrisya.cid)
      sirabasu.each do |i|
      @sirabasuuser = Sirabasuuser.new(
        kanrisya_id: @kanrisya.id,
        sirabasu_id: i.id
      )
      @sirabasuuser.save
      end
      #中間テーブルへの保存ここまで
      redirect_to "/user/index"
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end

  def edit
    if current_kanrisya.admin == true
     @kanrisya = Kanrisya.find(params[:id])
    else
     redirect_to "/user/not"
   end
  end

  def update
    @kanrisya = Kanrisya.find(params[:id])
    @kanrisya.update(kanrisya_params)
    redirect_to user_path
  end

  def destroy
      @kanrisya = Kanrisya.find(params[:id])
      @kanrisya.destroy
      redirect_to "/user/index"
  end

  def kanrisya_params
  params.require(:kanrisya).permit(:name, :email, :password, :password_confirmation, :crew_number, :age, :sex, :admin, :cid, :image, :belong)
  end

  def company_params
  params.require(:company).permit(:cname, :cid, :password)
  end

  def user_top

  end
  def sirabasu
    @sirabasus = Sirabasu.all
  end
end

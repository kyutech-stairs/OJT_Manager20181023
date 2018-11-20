class UserController < ApplicationController

  def index
    @user = Kanrisya.where(name: params[:name])
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
    @check_parcent = ((@check_ok_count/@check_count.to_f).round(2)*100).to_i
    #ユーザーに関連するシラバスの情報
    @sirabasu = Sirabasu.where(cid: @kanrisya.cid)
    i = 0
    @sirabasu_check_ok_parcent = []
    while i < @sirabasu.count do
     #シラバスに関係するチェックリストの取得
     @sirabasu_check = @sirabasu[i].checklists.all
     #チェックリストに関連するチェック判定の取得
     @sirabasu_check_ok = 0
     @sirabasu_check.each do |sirabasu_check|
      sirabasu_check_ok = Checkuser.where(checklist_id: sirabasu_check.id).where(kanrisya_id: @kanrisya.id).where(check_ok: true)
      @sirabasu_check_ok = @sirabasu_check_ok + sirabasu_check_ok.count
     end
     @sirabasu_check_ok_parcent[i] = ((@sirabasu_check_ok/(@sirabasu_check.count).to_f).round(2)*100).to_i
     i = i + 1
    end
    @sirabasuuser = []
    @sirabasu.each do |sirabasu|
    @sirabasuuser[sirabasu.id] = Sirabasuuser.find_by(kanrisya_id: @kanrisya.id, sirabasu_id: sirabasu.id)
    end
   end
  end

  def search
  end

  def search_result
  end

  def hei

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

  def user_top

  end
  def sirabasu
    @sirabasus = Sirabasu.all
  end
end

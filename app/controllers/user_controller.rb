class UserController < ApplicationController

  def index
     @kanrisya = Kanrisya.all
  end

  def show
     @kanrisya = Kanrisya.find(params[:id])
  end

  def hei

  end

  def new
    if current_kanrisya.admin == true
     @kanrisya = Kanrisya.new
    else
      redirect_to "/user/not"
    end
  end

  def create
    @kanrisya = Kanrisya.new(kanrisya_params)

    if @kanrisya.save
      flash[:success] = '新しいユーザーを登録しました。'
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
  params.require(:kanrisya).permit(:name, :email, :password, :password_confirmation, :crew_number, :age, :sex, :admin, :cid)
  end

  def user_top

  end
  def check_rist
    @sirabasus = Sirabasu.all
  end
  def sirabasu
    @sirabasus = Sirabasu.all
  end
end

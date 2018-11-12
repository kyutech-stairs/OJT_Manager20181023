class CrewsController < ApplicationController
  def index
    @crews = Crew.all
  end

  def show
    @crew = Crew.find(params[:id])
  end

  def new
    @crew = Crew.new
  end

  def create
    @crew = Crew.new(crew_params)

    if @crew.save
      flash[:success] = '新しいユーザーを登録しました。'
      redirect_to @crew
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @crew = Crew.find(params[:id])
  end

  def update
    @Crew = Crew.find(params[:id])
    @Crew.update(crew_params)
    redirect_to crews_path
  end

  def destroy
      @crew = Crew.find(params[:id])
      @crew.destroy
      redirect_to crews_path
  end

  def crew_params
  params.require(:crew).permit(:name, :email, :password, :password_confirmation, :crew_number, :age, :sex, :image)
  end
end

class SessionsController < ApplicationController
  before_action :require_sign_in!, only: [:destroy]
  before_action :set_user, only: [:create]
  def new
  end

  def create
    if @crew.authenticate(session_params[:password])
     #sign_in(@crew)
     #redirect_to action: `index`
      redirect_to "/user/user_top"
   else
     flash.now[:danger] = t('.flash.invalid_password')
     render 'new'
   end
  end

  def destroy
    sign_out
    redirect_to login_path
  end

  def index
    @crew = Session.find(params[:id])
  end

  def set_user
      @crew = Crew.find_by!(crew_number: session_params[:crew_number])
    rescue
      flash.now[:danger] = t('.flash.invalid_mail')
      render action: 'new'
    end

    # 許可するパラメータ
    def session_params
      params.require(:session).permit(:crew_number, :password)
    end
end

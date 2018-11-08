class SirabasusController < ApplicationController
    def index
      @sirabasu = Sirabasu.all.order(:number)
      #@checklist = Checklist.all.order(:number)
    end

    def show
      @sirabasu = Sirabasu.find_by(number: params[:id])
      @kanrisya = Kanrisya.find_by(id: @sirabasu.userid)
      @checklist = @sirabasu.checklists.all
    end


    def new
      if current_kanrisya.admin == true
       @sirabasu = Sirabasu.new
       @new_num = Sirabasu.count + 1
      else
        redirect_to "/user/not"
      end
    end

    def create
      @sirabasu = Sirabasu.new(sirabasu_params)
      @new_num = Sirabasu.count + 1
      if @sirabasu.save
     redirect_to("/sirabasus")
      else
      render "new"
      end
    end

    # データを更新するためのAction
    def update
      @sirabasu = Sirabasu.find(params[:id])
      @sirabasu.update(sirabasu_params)
      redirect_to :action => "index"
    end

    def edit
      if current_kanrisya.admin == true
       @sirabasu = Sirabasu.find(params[:id])
     else
       redirect_to "/user/not"
     end
    end

    # データを削除するためのAction
    def destroy
      if current_kanrisya.admin == true
       @sirabasu = Sirabasu.find(params[:id])
       @sirabasu.destroy
       @sirabasu = Sirabasu.all
       i = 1
       @sirabasu.each do |sira|
        sira.number = i
        sira.save
        i += 1
       end
       #@sirabasu.save
       redirect_to sirabasus_path
      else
        redirect_to "/user/not"
      end
    end

    def sirabasu_params
      params.require(:sirabasu).permit(:number,:name,:content,:userid,:cid)
    end

    def user_params
      params.require(:kanrisya).permit(:id,:name,:cid)
    end
end

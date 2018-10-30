class SirabasusController < ApplicationController
    def index
      @sirabasu = Sirabasu.all.order(:number)
      #@checklist = Checklist.all.order(:number)
    end

    def show
      @sirabasu = Sirabasu.find_by(number: params[:id])
      @checklist = @sirabasu.checklists.all
    end


    def new
      @sirabasu = Sirabasu.new
      @new_num = Sirabasu.count + 1
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
      @sirabasu = Sirabasu.find_by(number: params[:id])
    end

    # データを削除するためのAction
    def destroy
      @sirabasu = Sirabasu.find_by(number: params[:id])
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
    end

    def sirabasu_params
      params.require(:sirabasu).permit(:number,:name,:content)
    end
end

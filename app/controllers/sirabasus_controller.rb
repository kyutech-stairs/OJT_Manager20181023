# frozen_string_literal: true
#シラバスと画像を保存するための操作をもつ
class SirabasuForm
  include Virtus.model
  include ActiveModel::Model

  attr_accessor :number, :name, :content, :userid, :cid, :image_path
# attribute number: Integer
# attribute name: String

  validates :name, :content, presence: true

  # def initialize(attr = {})
  #   puts '初期化'
  #   unless attr["number"].nil?
  #     puts 'numberでfind'
  #     @sirabasu = Sirabasu.find_by(number: attr["number"])
  #     puts '見つけた' #コンソール表示用（なくてもよい）
  #     puts @sirabasu.id #コンソール表示用（なくてもよい）
  #     puts @sirabasu.name #コンソール表示用（なくてもよい）
  #     puts @sirabasu.content #コンソール表示用（なくてもよい）
  #     self[:name] = attr[:name].nil? ? @sirabasu.name : attr[:name]
  #     self[:content] = attr[:name].nil? ? @sirabasu.content : attr[:name]
  #   end
  # end

  def save(sirabasu_form_params)
    # return false if invalid?

    sirabasu = Sirabasu.new(name: name, content: content, number: number, userid: userid, cid: cid)
# sirabasu.save
    unless sirabasu_form_params[:image_path].nil?
      sirabasu_form_params[:image_path].each do |path|
        sirabasu.images.new(image_path: path)
      end
    end
    sirabasu.save
  end

  # def update(sirabasu_form_params)

  #   @sirabasu.update(name: name, content: content, number: number, userid: userid, cid: cid)
  # end
end

class SirabasusController < ApplicationController
  def index
    @sirabasu = Sirabasu.where(cid: current_kanrisya.cid).order(:number)
    # @checklist = Checklist.all.order(:number)
  end

  def show
    @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
    @images = @sirabasu.images.all
    # @kanrisya = Kanrisya.find_by(id: @sirabasu.userid)
    @kanrisya = Kanrisya.find(@sirabasu.userid)
    @checklist = @sirabasu.checklists.all
  end

  def new
    if current_kanrisya.admin == true
      # @sirabasu = Sirabasu.new
      # @sirabasu.images.build
      @sirabasu_form = SirabasuForm.new
      @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1

    else
      redirect_to '/user/not'
    end
  end

  def create
    # @sirabasu = Sirabasu.new(sirabasu_form_params)
    @sirabasu_form = SirabasuForm.new(sirabasu_form_params)
    @new_num = Sirabasu.where(cid: current_kanrisya.cid).count + 1
    # if @sirabasu.save
    if @sirabasu_form.save(sirabasu_form_params)
      redirect_to('/sirabasus')
    else
      render 'new'
    end
  end

  def edit
    if current_kanrisya.admin == true
      @sirabasu = Sirabasu.find_by(number: params[:id], cid: current_kanrisya.cid)
      # @sirabasu_form = SirabasuForm.new("number" => params[:id])
    else
      redirect_to '/user/not'
   end
  end

  # データを更新するためのAction
  def update
    # ここちょっとよくわからないですね（by 吉井）
    @sirabasu = Sirabasu.find_by(id: params[:id], cid: current_kanrisya.cid)
    # @sirabasu_form = SirabasuForm.new(sirabasu_form_params.merge("number" => params[:id]))
    # if @sirabasu.update(sirabasu_form_params)
    if @sirabasu_form.update(sirabasu_form_params)
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
      # @sirabasu.save
      redirect_to sirabasus_path
    else
      redirect_to '/user/not'
    end
  end

  def sirabasu_form_params
    # params.require(:sirabasu).permit(:number, :name, :content, :userid, :cid, sirabasus_attributes: [:image_path])
    params.require(:sirabasu_form).permit(:number, :name, :content, :userid, :cid, image_path: [])
  end

    def user_params
      params.require(:kanrisya).permit(:id,:name,:cid, check:[])
    end
end

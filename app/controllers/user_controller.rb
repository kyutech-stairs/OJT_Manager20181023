class UserController < ApplicationController
  def user_top
    
  end
  def check_rist
    @sirabasus = Sirabasu.all
  end
  def sirabasu
    @sirabasus = Sirabasu.all
  end
end

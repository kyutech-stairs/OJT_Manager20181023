# frozen_string_literal: true

Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  get 'sessions/index'
  get 'crews/index'
  get 'crews/show'
  get 'crews/new'
  get 'crews/create'
  get 'crews/edit'
  get 'crews/update'

  # ログイン / ログアウト
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get 'ojt_top/kanri'
  get 'ojt_top/user'

  devise_for :kanrisyas
  root 'menu#menu_top'
  devise_scope :social_account do
    get 'sign_out', to: 'menu#menu_top'
  end

  get 'menu/kanri'
  get 'menu/user'
  get 'menu/menu_top'

  get 'kanri/kanri_top'
  get 'kanri/sirabasu_make'
  get 'kanri/check_make'
  post 'kanri/check_create'
  get 'kanri/sintyoku_all'
  get 'kanri/sintyoku_user'
  get 'kanri/user_make'
  get 'kanri/kanri_user'


  resources :sirabasus do
    resources :checklists
  end

  #get 'checklists/choose_sirabasus'
  #post 'checklists/:num/create' => 'checklists#create', as: 'new_checklist'
  #post 'checklists/:num/new' => 'checklists#new'
  #get 'checklists/:num/new' => 'checklists#new'
  

  get 'kanrisyas/new'

  resources :crews
  get 'crews/index'

  get 'user/user_top'
  get 'user/check_rist'
  get 'user/sirabasu'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

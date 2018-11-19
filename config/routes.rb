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

  get 'user/index'
  get 'user/show'
  get 'user/new'
  post 'user/create'
  get 'user/edit'
  get 'user/update'
  get 'user/hei'
  get 'user/not'

  # ログイン / ログアウト
  get     'login',   to: 'sessions#new'
  post    'login',   to: 'sessions#create'
  delete  'logout',  to: 'sessions#destroy'

  get 'ojt_top/kanri'
  get 'ojt_top/user'
  get 'ojt_top/top'

  root 'ojt_top#top'

  devise_for :kanrisyas, controllers: {
  sessions:      'kanrisyas/sessions',
  registrations:      'kanrisyas/registrations'
  }
  devise_scope :social_account do
    get 'sign_out', to: 'ojt_top#top'
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
    resources :checklists do
      resources :checkusers
    end
  end
  post "sirabasus/image_destroy"

  post 'checkusers/checkup'
  get 'checkusers/check'
  get 'checklists/checkuser'

  get 'kanrisyas/new'

  resources :crews
  resources :user do
    resources :checkusers
  end

  get 'crews/index'

  get 'user/user_top'
  get 'user/check_rist'
  get 'user/sirabasu'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

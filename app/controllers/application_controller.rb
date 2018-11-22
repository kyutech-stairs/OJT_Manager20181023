class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_kanrisya!
  config.assets.initialize_on_precompile = false

   protected

     def configure_permitted_parameters
       devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :age, :crew_number, :sex, :admin, :cid, :check, :image, :belong])
       devise_parameter_sanitizer.permit(:account_update, keys: [:name, :age, :crew_number, :sex, :admin, :cid, :check, :image, :belong])
     end
end

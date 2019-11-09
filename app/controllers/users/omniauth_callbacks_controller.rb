class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env["omniauth.auth"])
    
  #   if @user.persisted?
  #     sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
      
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to new_user_registration_url
  #   end
  # end

  # def failure
  #   redirect_to root_path
  # end
  def all
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      session[:user_id] = user.id
      sign_in_and_redirect user, notice: 'Signed in!'
    else
      # Devise allow us to save the attributes eventhough
      # we havent create the user account yet
      session['devise.user_attributes'] = user.attributes
      # Because Twitter doesn't provide user's email, it would be nice
      # if we force user to enter it
      # manually on the registration page before we create their account.
      # Here we pass the callback parameter so that we could use it to
      # edit the registration page.
      redirect_to new_user_registration_url(callback: 'facebook')
    end
  end
  alias facebook all
end
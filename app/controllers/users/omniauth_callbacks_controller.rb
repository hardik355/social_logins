class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # skip_before_action :authenticate_user!, raise: false

  def all
    # p request.env["omniauth.auth"]
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.persisted?
      session[:user_id] = user.id
      sign_in_and_redirect user, notice: 'Signed in!'
    else
      session['devise.user_attributes'] = user.attributes
      redirect_to new_user_registration_url
    end
  end

  def failure
    # super
  end
 
    alias_method :facebook, :all
    alias_method :linkedin, :all
    alias_method :twitter, :all 
    alias_method :github, :all
    alias_method :google_oauth2, :all
end
    
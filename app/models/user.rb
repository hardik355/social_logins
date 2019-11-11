class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          # :omniauthable, omniauth_providers: %i[facebook]
          :omniauthable, omniauth_providers: [:google_oauth2, :facebook, :linkedin]

def self.from_omniauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.present?
      user
    else
      # Check wether theres is already a user with the same
      # email address
      user_with_email = User.find_by_email(auth.info.email)
      if user_with_email.present?
        user = user_with_email
      else
        user = User.new
        if auth.provider == 'facebook'
          where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
          user.email = auth.info.email
          user.password = Devise.friendly_token[0,20]
          user.first_name = auth.info.name
          user.last_name = auth.info.name
          user.uid = auth.uid
          user.provider = auth.provider
          user.oauth_token = auth.credentials.token 
        end
          
        elsif auth.provider == 'linkedin'
            user.email = auth.info.email
            user.password = Devise.friendly_token[0,20]
            user.first_name = auth.info.name
            user.last_name = auth.info.name
            user.uid = auth.uid
            user.provider = auth.provider
            user.oauth_token = auth.credentials.token
          user.save
          p user

        elsif auth.provider == 'google_oauth2'
          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          # Google's token doesn't last forever
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.save
        end
      end
    end
    user
  end
end

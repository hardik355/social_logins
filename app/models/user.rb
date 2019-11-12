class User < ApplicationRecord
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable,
          :omniauthable, omniauth_providers: [:google_oauth2, :facebook, :linkedin, :twitter, :github]

def self.from_omniauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    if user.present?
      user
    else
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
          user.save
        end

        elsif auth.provider == 'twitter'
          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.oauth_user_name = auth.extra.raw_info.name
          user.save!(validate: false)
         
        elsif auth.provider == 'github'
          user.provider = auth['provider']
          user.uid = auth['uid']
          user.oauth_user_name = auth['info']['name']
          user.save
          
        elsif auth.provider == 'linkedin'
          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          user.save

        elsif auth.provider == 'google_oauth2'
          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          user.oauth_token = auth.credentials.token
          # Google's token doesn't last forever
          user.oauth_expires_at = Time.at(auth.credentials.expires_at)
          user.save!(validate: false)
        end
      end
    end
    user
  end

  # For Twitter (disable password validation)

  def password_required?
    super && provider.blank?
  end
  
end

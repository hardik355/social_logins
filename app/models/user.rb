class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise  :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: %i[facebook]
          
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
          # If you are using confirmable and the provider(s) you use validate emails,
          # uncomment the line below to skip the confirmation emails.
          end
          
        elsif auth.provider == 'linkedin'

          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.first_name = auth.info.first_name
          user.last_name = auth.info.last_name
          user.email = auth.info.email
          user.save

        elsif auth.provider == 'twitter'
          user.provider = auth.provider
          user.uid = auth.uid
          user.oauth_token = auth.credentials.token
          user.oauth_user_name = auth.extra.raw_info.name

        elsif auth.provider == 'github'
          user.provider = auth['provider']
          user.uid = auth['uid']
          user.oauth_user_name = auth['info']['name']
          user.email = auth['info']['email']
          user.save

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
